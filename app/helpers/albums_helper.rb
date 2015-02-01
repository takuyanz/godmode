module AlbumsHelper
  def album(album)
    klass = ""
    klass += "box" if album.id == 5
    "<div class=\"hoge #{klass}\"></div>".html_safe
  end

  def link_to_album(album)
    link_to("hoge", album.album_name)
  end


  # change timeline event index
  # within view call, helper methods to create html dom
  # remove partial instead create view for each action and call helper method 
end
