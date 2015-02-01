class LikesController < ApplicationController
  before_action :authenticate
  
  def create
    liked_status = Like.up_down(params[:album_id], params[:like_status], current_user.id)

    # only notify when album is liked / ignore dislikes
    if liked_status

      # inform user about new like
      follower_ids = current_user.followers.pluck(:id)
      Websocket.inform_followers_new_like(follower_ids)

      album = Album.find(params[:album_id])
      liked_user_id = album.user_id

      condition = {to_user_id: liked_user_id, from_user_id: current_user.id, event_type: "like", album_id: album.id}

      # dont notify when already notified or myself
      if !Notification.find_by(condition) && current_user.id != liked_user_id
        Notification.create(condition)
        data = Notification.create_like_notification(current_user, album)
        Websocket.notify_user_like(liked_user_id, data) 
      end
    end

    render nothing: true
  end

  def check_liked
    like = Like.find_by(album_id: params[:album_id], user_id: current_user.id)
    like.blank? ? status = 0 : status = 1
    
    render nothing: true, json: status
  end
end
