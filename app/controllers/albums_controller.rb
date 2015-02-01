class AlbumsController < ApplicationController
  before_action :authenticate, :new_album

  def create
    album = current_user.uploaded_albums.build(album_name: album_params[:album_name], story: (album_params[:story]).strip)
    if album.save
      album_params[:photo].each do |photo|
        album.uploaded_pictures.create(photo: photo)
      end
      Event.create(album_id: album.id, user_id: current_user.id)
      #inform followers about new album
      follower_ids = current_user.followers.pluck(:id)
      Websocket.inform_followers_new_album(follower_ids);

      redirect_to "/users/#{current_user.nickname}"
    else
      render status: 500
    end
  end

  def show
    album_id = params.require(:id)
    @albums = Album.where(id: album_id).includes(:user).includes(:uploaded_pictures)
  end

  def destroy 
    Album.find(params.require(:id)).destroy
    render nothing: true
  end
  
  private

  def album_params
    params.require(:album).permit(:album_name, :story, :photo => [])
  end
end
