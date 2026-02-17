# frozen_string_literal: true

# Sync ActiveRecord writes to Cloudflare D1 when running in a CF container.
# Only active when CF_D1_DATABASE_ID, CF_API_TOKEN, and CF_ACCOUNT_ID are set.

if ENV["CF_D1_DATABASE_ID"].present?
  require_relative "../../lib/d1_sync"

  Rails.application.config.after_initialize do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.include(D1SyncCallbacks)
    end
  end

  module D1SyncCallbacks
    extend ActiveSupport::Concern

    included do
      after_create_commit :d1_sync_create
      after_update_commit :d1_sync_update
      after_destroy_commit :d1_sync_destroy
    end

    private

    def d1_sync_create
      columns = attributes.keys
      placeholders = columns.map { "?" }.join(", ")
      values = attributes.values
      sql = "INSERT INTO #{self.class.table_name} (#{columns.join(', ')}) VALUES (#{placeholders})"
      D1Sync.push_query(sql, values)
    end

    def d1_sync_update
      changed_attrs = previous_changes.except("updated_at")
      return if changed_attrs.empty?

      sets = attributes.keys.map { |c| "#{c} = ?" }.join(", ")
      values = attributes.values + [id]
      sql = "UPDATE #{self.class.table_name} SET #{sets} WHERE id = ?"
      D1Sync.push_query(sql, values)
    end

    def d1_sync_destroy
      D1Sync.push_query(
        "DELETE FROM #{self.class.table_name} WHERE id = ?",
        [id]
      )
    end
  end
end
