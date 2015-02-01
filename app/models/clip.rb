class Clip < ActiveRecord::Base
  belongs_to :user, foreign_key: :stared_user_id

  def self.clipped_users_by(user_id)
    where(staring_user_id: user_id).includes(:user).order("created_at ASC")
  end
 
end
