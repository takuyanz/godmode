class CreateTables < ActiveRecord::Migration
  def change
    create_table "albums", force: true do |t|
      t.integer  "user_id",    null: false
      t.string   "album_name", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "pictures", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "pic_name",   null: false
      t.integer  "album_id",   null: false
    end

    create_table "users", force: true do |t|
      t.string   "name",       null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "uid",        null: false
      t.string   "provider",   null: false
      t.string   "nickname",   null: false
      t.string   "image_url",  null: false
    end
  end
end
