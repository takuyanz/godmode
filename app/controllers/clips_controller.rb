class ClipsController < ApplicationController
  before_action :authenticate

  def switch
    stared_user_id = params.require(:stared_user_id)
    clip_status = Clip.find_by(staring_user_id: current_user.id, stared_user_id: stared_user_id)

    # if user is already clipped. destroy else create new
    if clip_status.blank?
      Clip.create(staring_user_id: current_user.id, stared_user_id: stared_user_id)
      render text: "clipped" and return
    else
      clip_status.destroy!
      render text: "unclipped" and return
    end
  end
end
