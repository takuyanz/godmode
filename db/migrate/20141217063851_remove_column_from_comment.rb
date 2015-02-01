class RemoveColumnFromComment < ActiveRecord::Migration
  def up
    remove_column  :comments, :album_id, :integer
    add_column     :comments, :commented_user_id, :integer
  end

  def down
    add_column     :comments, :album_id, :integer
    remove_column  :comments, :commented_user_id, :integer
  end
end
