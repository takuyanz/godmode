class RelationshipsController < ApplicationController
  before_action :authenticate, :new_album

  def update
    other_user_id = params[:id]
    if current_user.following?(other_user_id)
      current_user.unfollow!(other_user_id)
    else
      current_user.follow(other_user_id)

      condition = {to_user_id: other_user_id, from_user_id: current_user.id, event_type: "follow"}
      if !Notification.find_by(condition)
        nf = Notification.create(condition)
        nf_msg = current_user.nickname + " started following you"
        link_to = "/users/#{current_user.nickname}"
        data = [{nf_msg: nf_msg, image_url: current_user.image_url, link_to: link_to}].to_json

        WebsocketRails.users[other_user_id].send_message(:notification, data)
      end
    end
    render json: true
  end
end
