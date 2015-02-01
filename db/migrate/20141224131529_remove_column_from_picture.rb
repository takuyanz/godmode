class RemoveColumnFromPicture < ActiveRecord::Migration
  def up
    remove_column :pictures, :pic_name, :string
  end

  def down
    add_column    :pictures, :pic_name, :string
  end
end
