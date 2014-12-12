class OrderReceivesController < ApplicationController
	before_filter :authenticate_user!
	def index
		@bookings = Booking.where('poster_id = ?', current_user.id  )
	end
end
