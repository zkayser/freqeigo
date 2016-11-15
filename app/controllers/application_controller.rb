class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end
  
  def current_admin?
    return true if current_user.admin?
  end
  
  # Run this as one before action on any controller that requires
  # a paid, logged in user.
  def check_active_user
    if !current_user.active?
      current_user.plan = nil
    end
  end
end
