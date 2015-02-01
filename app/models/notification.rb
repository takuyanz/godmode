class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :album, foreign_key: 'album_id'

  def self.create_notifications(user)
    # link info follow -> nill message -> nickname, like -> album.id
    
    #avoiding the duplicates
    #this method or order created then compared the ids
    notifications = []
    Notification.where(to_user_id: user.id).order("created_at DESC").each do |n|
      if notifications.count <= 4 && n.present?
        if notifications.empty?
          notifications.push(n)
        else
          if n.event_type == "message"
            bool = false
            notifications.each do |nf|
              if nf.to_user_id == n.to_user_id && nf.from_user_id == n.from_user_id && nf.event_type == n.event_type
                bool = true
                break
              else
                bool = false
              end
            end
            notifications.push(n) if !bool
          else
            notifications.push(n)
          end
        end
      end
    end

    notification_data = []
    notifications.each do |notification|
      from_user          = User.find(notification.from_user_id)
      from_user_nickname = from_user.nickname
      from_user_image_url = from_user.image_url

      case notification.event_type
      when "like"
        album = Album.find(notification.album_id)
        message = from_user_nickname + " liked your album " + album.album_name
        link_to = "/albums/#{album.id}"
      when "message"
        message = from_user_nickname + " messaged you"
        link_to = "/messages/#{from_user_nickname}"
      when "follow"
        message = from_user_nickname + " started following you"
        link_to = "/users/#{from_user_nickname}"
      when "comment"
        message = from_user_nickname + " commented in freetalk"
        link_to = "/comments"
      end

       notification_data.push({nf_msg: message, image_url: from_user_image_url, link_to: link_to})
    end

    return notification_data
  end

  def self.create_like_notification(current_user, album)
    nf_msg = current_user.nickname + " liked your album " + album.album_name
    link_to = "/albums/#{album.id}"
    return [{nf_msg: nf_msg, image_url: current_user.image_url, link_to: link_to}].to_json
  end

  def self.create_message_notification(current_user)
    nf_msg = current_user.nickname + " messaged you"
    link_to = "/messages/#{current_user.nickname}"
    return [{nf_msg: nf_msg, image_url: current_user.image_url, link_to: link_to}].to_json
  end

  def self.create_comment_notification(current_user)
    nf_msg = current_user.nickname + " commented in your freetalk"
    link_to = "/users/comments"
    return [{nf_msg: nf_msg, image_url: current_user.image_url, link_to: link_to}].to_json
  end
end
