class AddColumnToMessage < ActiveRecord::Migration
  def up
    add_column :messages, :seen_at, :datetime
  end

  def down
    remove_column :messages, :seen_at, :datetime
  end
end
