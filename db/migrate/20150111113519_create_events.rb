class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :album_id
      t.integer :like_id
      t.integer :user_id

      t.timestamps
    end
  end
end
