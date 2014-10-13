class AuthenticatesController < ApplicationController

	respond_to :html, :js, :json
	
	def index
	end

	def create
		session[:email] = params[:email]
		redirect_to new_user_registration_path
	end

	def check_email
		@user = User.find_by_email(params[:email])
		respond_to do |format|
			format.json { render :json => !@user }
		end
	end

end
