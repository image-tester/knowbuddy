class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!, unless: :admin_request

  helper_method :tag_cloud

  def admin_request
    (params[:controller].include? "admin")
  end
end