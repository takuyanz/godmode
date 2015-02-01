# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150131081156) do

  create_table "albums", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "album_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "story"
  end

  add_index "albums", ["user_id", "created_at"], name: "index_albums_on_user_id_and_created_at"

  create_table "clips", force: true do |t|
    t.integer  "staring_user_id", null: false
    t.integer  "stared_user_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clips", ["staring_user_id", "stared_user_id"], name: "index_clips_on_staring_user_id_and_stared_user_id"

  create_table "comments", force: true do |t|
    t.string   "comment",           null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commented_user_id"
  end

  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "events", force: true do |t|
    t.integer  "album_id"
    t.integer  "like_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "likes", force: true do |t|
    t.integer  "album_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["user_id", "album_id", "created_at"], name: "index_likes_on_user_id_and_album_id_and_created_at"

  create_table "messages", force: true do |t|
    t.integer  "message_to_id",   null: false
    t.integer  "message_from_id", null: false
    t.text     "text",            null: false
    t.boolean  "seen_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seen_by"
    t.datetime "seen_at"
  end

  add_index "messages", ["message_to_id", "message_from_id"], name: "index_messages_on_message_to_id_and_message_from_id"

  create_table "notifications", force: true do |t|
    t.integer  "from_user_id", null: false
    t.integer  "to_user_id",   null: false
    t.string   "event_type",   null: false
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id"
  end

  create_table "pictures", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "album_id",           null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "pictures", ["album_id"], name: "index_pictures_on_album_id"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "replies", force: true do |t|
    t.integer  "comment_id"
    t.string   "reply_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "replies", ["comment_id"], name: "index_replies_on_comment_id"

  create_table "users", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",        null: false
    t.string   "provider",   null: false
    t.string   "nickname",   null: false
    t.string   "image_url",  null: false
    t.text     "bio"
  end

  create_table "websockets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
