class EventsController < ApplicationController
  before_action :authenticate, :new_album

  def index
    following_ids = current_user.followed_users.pluck(:id)

    # if offset then loading more events by ajax
    if params["offset_num"].blank?
      offset_num = 0
      offset_status = false
    else
      offset_num = params["offset_num"]
      offset_status = true
    end

    @events = Event.timeline_by_user_ids(following_ids, offset_num)

    if offset_status 
      render partial: "show_events"
    end

  end
end
