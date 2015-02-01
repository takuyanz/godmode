class SearchController < ApplicationController
  before_action :authenticate, :new_album

  def index
    @@search_keywords = params[:q]
    case params[:c]
    when "all"
      # search(keyword, limit, offset)
      @users = User.search(@@search_keywords, 5, 0)
      @albums = Album.search(@@search_keywords, 5, 0)
    when "users"
      @users = User.search(@@search_keywords, 10, 0)
    when "albums"
      @albums = Album.search(@@search_keywords, 10, 0)
    end
  end

  def load_more_albums
    offset_num = params.require(:offset_num)
    @albums = Album.search(@@search_keywords, 5, offset_num)

    render partial: "shared/create_album_box"
  end

  def load_more_users
    offset_num = params.require(:offset_num).to_i + 5
    @users = User.search(@@search_keywords, 5, offset_num)

    render partial: "create_user_result"
  end
end
