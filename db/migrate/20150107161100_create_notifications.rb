class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer  "notifying_user_id",   null: false
      t.integer  "notified_user_id",    null: false
      t.string   "event_name",          null: false
      t.integer  "content_id"

      t.timestamps
    end
  end
end
