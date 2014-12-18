class AuthenticatesController < ApplicationController

	#http://stackoverflow.com/questions/20875591/actioncontrollerinvalidauthenticitytoken-in-registrationscontrollercreate
	skip_before_filter :verify_authenticity_token, :only => :create
	
	respond_to :html, :js, :json
	
	def index
	end

	def create

		session[:email] = params[:email]

      	respond_to do |format|
			format.js
		end
      	
    
	end

	def check_email
		@user = User.find_by_email(params[:email])
		respond_to do |format|
			format.json { render :json => !@user }
		end
	end

end
