class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_params, if: :devise_controller?
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) {|u|
      u.permit(:name, :last_name, :personal_email, :mobile_number,:email, :password, :password_confirmation)}

      devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:name, :last_name, :personal_email, :mobile_number,:email, :password, :password_confirmation,:current_password) }
  end

  def after_sign_in_path_for(curent_user)
     if curent_user.admin?
       admins_path 
     else
      posts_overview_path
     end
  end

end
