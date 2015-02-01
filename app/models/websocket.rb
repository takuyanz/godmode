class Websocket < ActiveRecord::Base

  def self.inform_followers_new_album(follower_ids)
    follower_ids.each do |follower_id|
      WebsocketRails.users[follower_id].send_message(:new_event, 1)
    end
  end

  def self.inform_followers_new_like(follower_ids)
    follower_ids.each do |follower_id|
      WebsocketRails.users[follower_id].send_message(:new_event, 1)
    end
  end

  def self.notify_user_like(user_id, data)
    WebsocketRails.users[user_id].send_message(:notification, data)
  end

  def self.notify_user_message(user_id, data)
    WebsocketRails.users[user_id].send_message(:notification, data)
  end

  def self.message_to_other_user(user_id, data)
    WebsocketRails.users[user_id].send_message(:websocket_message_to_other_user, data)
  end

  def self.message_to_current_user(user_id, data)
    WebsocketRails.users[user_id].send_message(:websocket_message_to_current_user, data)
  end

  def self.count_up_offset(user_id)
    WebsocketRails.users[user_id].send_message(:offset_count_up, "_")
  end

  def self.mark_seen(user_id, data)
    WebsocketRails.users[user_id].send_message(:print_seen, data)
  end

end
