class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!, unless: :active_admin_request?

  helper_method :tag_cloud

  def active_admin_request?
    (params[:controller].include? "admin")
  end
end
