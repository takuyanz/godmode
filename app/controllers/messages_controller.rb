class MessagesController < ApplicationController
  before_action :authenticate, :new_album

  def index
    @clipped_users = Clip.clipped_users_by(current_user.id)
  end

  def create
    message_to_id = params.require(:message_to_id)
    message_text = params.require(:message_text)
    message = Message.new(message_to_id: message_to_id, message_from_id: current_user.id, text: message_text)

    if message.save
      message_data = Message.create_message_data(message_text, current_user, message)

      # websocketing to both users that are exchanging messages vis websocket
      Websocket.message_to_other_user(message_to_id, message_data)
      Websocket.message_to_current_user(current_user.id, message_data)
      Websocket.count_up_offset(current_user.id)

      # notifying users for new messages via websocket
      Notification.create(to_user_id: message_to_id, from_user_id: current_user.id, event_type: "message")
      data = Notification.create_message_notification(current_user)
      Websocket.notify_user_message(message_to_id, data)

      render nothing: true
    else
      render status: 500
    end
  end

  def show
    nickname = params.require(:id)
    @message_to_user = User.find_by(nickname: nickname)
    messages = Message.between_two_users(@message_to_user.id, current_user.id, 20, 0)
    if messages.present? && messages.last.seen_status != true
      messages.last.seen_status = true
      messages.last.seen_at = Time.zone.now
      messages.last.save!
    end

    @messages = messages

    # diplaying seen status via websocket
    data = Message.create_seen_status_data(@messages.last, current_user)
    Websocket.mark_seen(@messages.last.message_from_id, data)

    if request.headers["X-PJAX"]
      # load part of the page
      render partial: "show_message" and return
    else
      # reload the whole page
      @clipped_users = Clip.clipped_users_by(current_user.id)
      render "index" and return
    end
  end

  def load_more_messages
    offset = params.require(:offset)
    user_messaging_with = User.find_by(nickname: params.require(:message_with))
    @messages = Message.between_two_users(user_messaging_with.id, current_user.id, 20, offset)

    render partial: "messages"
  end
  
  def search_user
    search_keywords = params["search_keywords"].strip
    @search_results = Message.chattable_users_for_user(current_user, search_keywords)
    
    render partial: "search_user"
  end

  # when star is clicked, bring the stared users on top using ajax
  def show_clipped
    @clipped_users = Clip.clipped_users_by(current_user.id)
    
    render partial: "show_clipped"
  end

  def mark_seen
    last_message = Message.find(params.require(:message_id))
    if last_message.message_to_id == current_user.id && last_message.seen_status != true
      last_message.seen_status = true
      last_message.seen_at = Time.zone.now
      last_message.save!

      data = Message.create_seen_status_data(last_message, current_user)
      Websocket.mark_seen(last_message.message_from_id, data)
    end

    render nothing: true
  end

end
