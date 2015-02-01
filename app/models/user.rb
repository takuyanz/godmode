class User < ActiveRecord::Base
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :uploaded_albums, class_name: 'Album'
  has_many :likes
  has_many :comments
  has_many :replies
  has_many :messages
  has_many :clips, :dependent => :destroy
  has_many :events, :dependent => :destroy

  before_destroy :delete_associated_notifications

  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid] 
    name = auth_hash[:info][:name]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.nickname = nickname
      user.image_url = image_url
    end
  end  

  def self.search(keyword, limit_num, offset_num)
    where("nickname like ?", "%#{keyword}%").limit(limit_num).offset(offset_num)
  end

  def following?(other_user)
    !!relationships.find_by(followed_id: other_user)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user).destroy
  end
  
  def follow(other_user)
    relationships.create!(followed_id: other_user)
  end

  def liked?(album)
    !!likes.find_by(album_id: album.id)
  end

  def album_count 
    uploaded_albums.count
  end

  def follower_count
    followers.count
  end

  def following_count
    followed_users.count
  end

  def album_count_text
    if uploaded_albums.count > 1
      text = "Albums"
    else
      text = "Album"
    end
  end

  def following_count_text
    if followed_users.count > 1
      text = "Followings"
    else
      text = "Following"
    end
  end

  def follower_count_text
    if followers.count > 1
      text = "Followers"
    else
      text = "Follower"
    end
  end

  def delete_associated_notifications
    Notification.where("from_user_id = ? OR to_user_id", self.id, self.id).destroy_all
  end

  def to_params
    nickname
  end

end
