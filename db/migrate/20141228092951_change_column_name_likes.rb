class ChangeColumnNameLikes < ActiveRecord::Migration
  def up
    rename_column :likes, :picture_id, :album_id
  end

  def down
    rename_column :likes, :album_id, :picture_id
  end
end
