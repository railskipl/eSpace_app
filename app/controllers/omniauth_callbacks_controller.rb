class OmniauthCallbacksController < ApplicationController

  

	# Facebook authentication
	def facebook
	    # You need to implement the method below in your model (e.g. app/models/user.rb)
	    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
	    
	    if @user.present?
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      flash.notice = "Signed in!" if is_navigational_format?
	    else
	      session["devise.facebook_data"] = request.env["omniauth.auth"]
	      redirect_to new_user_registration_url
	    end
  	end

   def failure
   		redirect_to root_path
   end
end
