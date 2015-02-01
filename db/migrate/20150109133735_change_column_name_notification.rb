class ChangeColumnNameNotification < ActiveRecord::Migration
  def up
    rename_column :notifications, :content_id, :link_info
  end

  def down
    rename_column :notifications, :link_info, :content_id
  end
end
