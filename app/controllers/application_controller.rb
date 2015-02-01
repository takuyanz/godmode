class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #before_action :new_album
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :authenticate, :album_exists?
  #rescue_from Exception, with: :error500
  #rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def error400(e)
    render 'error404', status: 404, formats: [:html]
  end
  
  def error500(e)
    logger.error [e, *e.backtrace].join("/n")
    render 'error500', status: 500, formats: [:html]
  end

  private

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    redirect_to welcome_path
  end
  
  def new_album
    @album = current_user.uploaded_albums.build
  end

end
