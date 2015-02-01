class AddIndexToEvent < ActiveRecord::Migration
  def up
    add_index :events, :user_id
  end

  def down
    remove_index :events, :user_id
  end
end
