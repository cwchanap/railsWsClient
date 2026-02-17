# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

# D1Sync provides methods to sync data between a local SQLite database
# and Cloudflare D1 via its REST API.
#
# Required environment variables:
#   CF_ACCOUNT_ID     - Cloudflare account ID
#   CF_D1_DATABASE_ID - D1 database ID
#   CF_API_TOKEN      - Cloudflare API token with D1 read/write access
module D1Sync
  API_BASE = "https://api.cloudflare.com/client/v4"

  class Error < StandardError; end

  class << self
    def enabled?
      ENV["CF_D1_DATABASE_ID"].present? &&
        ENV["CF_API_TOKEN"].present? &&
        ENV["CF_ACCOUNT_ID"].present?
    end

    def pull
      return unless enabled?

      tables = remote_tables
      Rails.logger.info("[D1Sync] Pulling #{tables.size} tables from D1")

      tables.each { |table_name| pull_table(table_name) }
    end

    def push_query(sql, binds = [])
      return unless enabled?

      Thread.new do
        d1_query(sql, binds)
      rescue StandardError => e
        Rails.logger.error("[D1Sync] Push failed: #{e.message}")
      end
    end

    def d1_query(sql, params = [])
      uri = URI("#{API_BASE}/accounts/#{account_id}/d1/database/#{database_id}/query")
      response = http_post(uri, { sql: sql, params: params })
      data = JSON.parse(response.body)

      unless data["success"]
        errors = data["errors"]&.map { |err| err["message"] }&.join(", ")
        raise Error, "D1 query failed: #{errors}"
      end

      data["result"]&.first
    end

    private

    def account_id = ENV.fetch("CF_ACCOUNT_ID")
    def database_id = ENV.fetch("CF_D1_DATABASE_ID")
    def api_token = ENV.fetch("CF_API_TOKEN")

    def remote_tables
      result = d1_query(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE '_cf_%'"
      )
      (result&.dig("results") || []).map { |r| r["name"] }
    end

    def pull_table(table_name)
      rows = fetch_table_rows(table_name)
      return if rows.empty?

      Rails.logger.info("[D1Sync] Pulling #{rows.size} rows for #{table_name}")
      columns = rows.first.keys

      ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
      insert_rows(table_name, columns, rows)
    rescue StandardError => e
      Rails.logger.error("[D1Sync] Failed to pull table #{table_name}: #{e.message}")
    end

    def fetch_table_rows(table_name)
      result = d1_query("SELECT * FROM #{table_name}")
      result&.dig("results") || []
    end

    def insert_rows(table_name, columns, rows)
      placeholders = columns.map { "?" }.join(", ")
      col_names = columns.join(", ")
      sql = "INSERT INTO #{table_name} (#{col_names}) VALUES (#{placeholders})"

      rows.each do |row|
        binds = columns.map do |col|
          ActiveRecord::Relation::QueryAttribute.new(col, row[col], ActiveRecord::Type::Value.new)
        end
        ActiveRecord::Base.connection.exec_insert(sql, "D1Sync", binds)
      end
    end

    def http_post(uri, body)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 10
      http.read_timeout = 30

      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{api_token}"
      request["Content-Type"] = "application/json"
      request.body = body.to_json

      http.request(request)
    end
  end
end
