class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :active_admin_request?

  helper_method :tag_cloud

  def active_admin_request?
    (params[:controller].include? "admin")
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end
end
