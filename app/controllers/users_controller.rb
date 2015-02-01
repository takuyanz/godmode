class UsersController < ApplicationController
  before_action :authenticate, :new_album

  def show
    @user = User.find_by(nickname: params[:id])
    @albums = @user.uploaded_albums.order('created_at DESC').includes(:uploaded_pictures).limit(5)
    @followings = @user.followed_users
    @followers = @user.followers
  end

  def load_more_albums 
    user = User.find(params.require(:user_id))
    offset_num = params.require(:offset_num)
    @albums = user.uploaded_albums.order('created_at DESC').includes(:uploaded_pictures).offset(offset_num).limit(5)

    render partial: "shared/create_album_box"
  end

  def update
    short_bio = params["short_bio"]
    id = params.require(:id)
    short_bio = nil if short_bio.blank?
    User.find(id).update(bio: short_bio)

    rtn_text = short_bio || 'Add a short bio by double clicking here and press enter to submit'
    render text: rtn_text
  end

end
