class AddIndexesToTables < ActiveRecord::Migration
  def up
    add_index :albums,    [:user_id, :created_at]
    add_index :clips,     [:staring_user_id, :stared_user_id]
    add_index :likes,     [:user_id, :album_id, :created_at]
    add_index :messages,  [:message_to_id, :message_from_id]
    add_index :comments,  :user_id
    add_index :pictures,  :album_id
    add_index :replies,   :comment_id
  end

  def down
    remove_index :albums,    [:user_id, :created_at]
    remove_index :clips,     [:staring_user_id, :stared_user_id, :created_at]
    remove_index :likes,     [:user_id, :album_id]
    remove_index :messages,  [:message_to_id, :message_from_id]
    remove_index :comments,  :user_id
    remove_index :pictures,  :album_id
    remove_index :replies,   :comment_id
  end
end
