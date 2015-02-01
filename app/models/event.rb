class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :like
  belongs_to :album

  def self.timeline_by_user_ids(user_ids, offset_num)
    #events = includes(like: :user).includes(like: [{album: :user}]).includes(:user).includes(album: :uploaded_pictures).includes(album: :user).where(user_id: user_ids).offset(offset_num).limit(5).order("created_at DESC")
    events = includes(:user).where(user_id: user_ids).offset(offset_num).limit(5).order("created_at DESC")
  end

end
