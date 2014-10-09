class HomeController < ApplicationController
# before_filter :authenticate_user!, :only => [ :show]
	def index
    @adminusers = User.where("admin =?",false)
	end


end