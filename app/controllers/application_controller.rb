class ApplicationController < ActionController::Base

  # protect_from_forgery
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :active_admin_request?

  helper_method :tag_cloud

  def active_admin_request?
    (params[:controller].include? "admin")
  end
end
