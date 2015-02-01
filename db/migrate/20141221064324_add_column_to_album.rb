class AddColumnToAlbum < ActiveRecord::Migration
  def up
    add_column  :albums, :story, :text
  end

  def down
    remove_column  :albums, :story, :text
  end
end
