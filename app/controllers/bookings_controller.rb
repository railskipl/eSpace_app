class BookingsController < ApplicationController

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
