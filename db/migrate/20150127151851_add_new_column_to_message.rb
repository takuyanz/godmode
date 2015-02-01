class AddNewColumnToMessage < ActiveRecord::Migration
  def up
    add_column :messages, :seen_by, :integer
  end

  def down
    remove_column :messages, :seen_by, :integer
  end
end
