class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

respond_to :html, :js

  # GET /resource/sign_up
  def new
    super

    respond_to do |format|
      format.js
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    @resource_saved = resource.save

    yield resource if block_given?

    if @resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      
      respond_with resource
    end
  end

  

  # GET /resource/edit
  def edit
     @user = current_user
  end
 
  # PUT /resource
   def update
    super
   end

  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # DELETE /resource
  def destroy
    super
  end

  def update
   super
  end


protected
  # account that is registered is confirmable and not active yet
   def after_inactive_sign_up_path_for(resource)
      new_user_session_path
   end


private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end

end
