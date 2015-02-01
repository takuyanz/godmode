class RemoveNotNullFromMessage < ActiveRecord::Migration
  def up
    change_column :messages, :seen_by, :integer, null: true
  end
   
  def down
    change_column :messages, :seen_by, :integer, null: false
  end
end
