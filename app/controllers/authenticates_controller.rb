class AuthenticatesController < ApplicationController

	def index
	end

	def create
		session[:email] = params[:email]
		redirect_to new_user_registration_path
	end

end
