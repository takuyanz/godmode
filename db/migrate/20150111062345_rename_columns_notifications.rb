class RenameColumnsNotifications < ActiveRecord::Migration
  def up
    rename_column :notifications, :notifying_user_id, :from_user_id
    rename_column :notifications, :notified_user_id,  :to_user_id
    rename_column :notifications, :event_name,        :event_type
    rename_column :notifications, :link_info,         :album_id
  end

  def down
    rename_column :notifications, :from_user_id, :notifying_id
    rename_column :notifications, :to_user_id,   :notified_id
    rename_column :notifications, :event_type,   :event_name
    rename_column :notifications, :album_id,     :link_info
  end
end
