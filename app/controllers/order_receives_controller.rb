class OrderReceivesController < ApplicationController
	before_filter :authenticate_user!
	def index
		@bookings = Booking.where('poster_id = ?', current_user.id  )
	end

	def search_order_received_by_date
	    if params[:start_date].blank? || params[:end_date].blank?
	      redirect_to order_receives_path, alert: "Please Select Date"
	    elsif  params[:start_date] > params[:end_date]
	      redirect_to  order_receives_path, alert: "Start Date Cannot Be Greater"
	    elsif params[:start_date] == params[:end_date]
	      @bookings = Booking.where("created_at >= ? and date(created_at) <= ? and poster_id = ?",params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    else
	      @bookings = Booking.where("date(created_at) >= ? and date(created_at) <= ? and poster_id = ?", params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    end
	end

	def payments
	   @bookings = Booking.where('poster_id = ? and stripe_charge_id is not null', current_user.id  )
	end
end
