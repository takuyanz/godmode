class NotificationsController < ApplicationController
  before_action :authenticate, :new_album

  def index
    notification_data = Notification.create_notifications(current_user)
    render json: notification_data
  end
end
