class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer   "message_to_id",    null: false
      t.integer   "message_from_id",  null: false
      t.text      "text",             null: false
      t.boolean   "seen_status"

      t.timestamps
    end
  end
end
