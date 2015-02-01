class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :album, foreign_key: :album_id
  has_many   :events, :dependent => :destroy
  
  def self.up_down(album_id, liked, user_id)

    if liked == "1"
      Like.find_by(album_id: album_id, user_id: user_id).destroy
      return false
    else
      like = Like.create(album_id: album_id, user_id: user_id)
      Event.create(like_id: like.id, user_id: like.user_id)
      return true
    end
  end

end
