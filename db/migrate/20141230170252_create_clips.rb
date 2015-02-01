class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.integer  "staring_user_id",   null: false
      t.integer  "stared_user_id",    null: false

      t.timestamps
    end
  end
end
