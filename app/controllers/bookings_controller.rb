class BookingsController < ApplicationController
 before_filter :authenticate_user!, :except => []
 def index
 	
 end
	def new
		@booking = Booking.new
	end

	def create
		raise "Amol"
	end

	def checkout
		
		session[:price] = params[:booking][:price]
        session[:user_id] = params[:booking][:user_id] 

        redirect_to new_booking_path
	end

end
