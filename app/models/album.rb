class Album < ActiveRecord::Base
  belongs_to :user
  has_many   :uploaded_pictures, class_name: 'Picture', :dependent => :destroy
  has_many   :likes,  :dependent => :destroy
  has_many   :events, :dependent => :destroy
  
  before_destroy :delete_associated_notifications

  def self.search(keyword, limit_num, offset_num)
    where("album_name like ?", "%#{keyword}%").includes(:user).includes(:uploaded_pictures).limit(limit_num).offset(offset_num)
  end

  def delete_associated_notifications
    Notification.where(album_id: self.id).destroy_all
  end

end
