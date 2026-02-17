# frozen_string_literal: true

namespace :d1 do
  desc "Pull data from Cloudflare D1 into local SQLite"
  task pull: :environment do
    require_relative "../d1_sync"

    unless D1Sync.enabled?
      puts "D1 sync not configured. Set CF_ACCOUNT_ID, CF_D1_DATABASE_ID, and CF_API_TOKEN."
      next
    end

    D1Sync.pull
    puts "D1 pull complete."
  end

  desc "Push local SQLite schema to Cloudflare D1"
  task push_schema: :environment do
    require_relative "../d1_sync"

    unless D1Sync.enabled?
      puts "D1 sync not configured. Set CF_ACCOUNT_ID, CF_D1_DATABASE_ID, and CF_API_TOKEN."
      next
    end

    push_application_tables
    push_meta_tables
    puts "D1 schema push complete."
  end
end

def push_application_tables
  conn = ActiveRecord::Base.connection
  meta_tables = %w[sqlite_master ar_internal_metadata schema_migrations]

  conn.tables.each do |table|
    next if meta_tables.include?(table)

    push_table_schema(conn, table)
  end
end

def push_table_schema(conn, table)
  create_sql = conn.execute(
    "SELECT sql FROM sqlite_master WHERE type='table' AND name='#{table}'"
  ).first&.fetch("sql")
  return unless create_sql

  puts "Creating table: #{table}"
  D1Sync.d1_query(create_sql)

  conn.execute(
    "SELECT sql FROM sqlite_master WHERE type='index' AND tbl_name='#{table}' AND sql IS NOT NULL"
  ).each do |idx|
    puts "Creating index: #{idx['sql']}"
    D1Sync.d1_query(idx["sql"])
  end
end

def push_meta_tables
  conn = ActiveRecord::Base.connection

  %w[schema_migrations ar_internal_metadata].each do |meta_table|
    create_sql = conn.execute(
      "SELECT sql FROM sqlite_master WHERE type='table' AND name='#{meta_table}'"
    ).first&.fetch("sql")
    next unless create_sql

    D1Sync.d1_query(create_sql)
    push_meta_table_rows(conn, meta_table)
  end
end

def push_meta_table_rows(conn, table)
  conn.execute("SELECT * FROM #{table}").each do |row|
    cols = row.keys.join(", ")
    placeholders = row.keys.map { "?" }.join(", ")
    D1Sync.d1_query("INSERT INTO #{table} (#{cols}) VALUES (#{placeholders})", row.values)
  end
end
