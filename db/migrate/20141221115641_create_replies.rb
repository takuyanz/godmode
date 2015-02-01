class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :comment_id
      t.string :reply_text

      t.timestamps
    end
  end
end
