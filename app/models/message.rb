class Message < ActiveRecord::Base
  belongs_to :user, foreign_key: :message_from_id

  def self.chattable_users_for_user(user, search_keywords)
    if search_keywords == ""
      return nil
    else
      # only show unstared users in search result
      clipped_users = Clip.where(staring_user_id: user.id).map {|clip| clip.user}
      results = user.followed_users.where("nickname like ?", "%#{search_keywords}%")
      return results.reject {|result| clipped_users.include?(result)}
    end
  end

  def self.between_two_users(to_id, from_id, limit_num, offset_num)
    where("(message_to_id = ? OR message_to_id = ?) AND (message_from_id = ? OR message_from_id = ?)", to_id, from_id, to_id, from_id).includes(:user).order("created_at DESC").limit(limit_num).offset(offset_num).reverse
  end
 
  def self.create_message_data(message_text, current_user, message)
    return {message: message_text, image_url: current_user.image_url, nickname: current_user.nickname, message_id: message.id, created_at: message.created_at.strftime("%X %d/%m")}.to_json
  end

  def seen_true(current_user)
    binding.pry
    message_to_id == current_user.id
    seen_status = true
    seen_at = Time.zone.now
    save!
  end

  def self.create_seen_status_data(last_message, current_user)
    return {seen_message: "seen #{last_message.seen_at.strftime("%X %d/%m")}", user_nickname: current_user.nickname}.to_json
  end
end
