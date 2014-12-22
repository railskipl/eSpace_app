class OmniauthCallbacksController < ApplicationController
	respond_to :html, :js, :json
  
     def new
     	@access_ids = AccessId.all
     	@user = User.new

     end

     def create
     	
     	@user = User.find_facebook_oauth(session["omniauth.auth"],params[:personal_email])

     	if @user.present?   
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      flash.notice = "Signed in!" if is_navigational_format?
	    else
	      session["omniauth.auth"] = request.env["omniauth.auth"]
	      redirect_to new_omniauth_callback_path
	           respond_to do |format|
			      # format.html { redirect_to home_all_postings_path, notice: 'Post status updated.' }
			      format.json {  render :json => !@user }
			    end
	    end

     end

	# Facebook authentication
	def facebook
		  
	    @user = User.is_present_facebook_oauth(request.env["omniauth.auth"])
	    if @user.present?   	
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      flash.notice = "Signed in!" if is_navigational_format?
	    else
	      session["omniauth.auth"] = request.env["omniauth.auth"]
	      redirect_to new_omniauth_callback_path
	    end
	 #    respond_to do |format|
		# format.json { render :json => !@user }
		# end
  	end

   def failure
   		redirect_to root_path
   end

end
