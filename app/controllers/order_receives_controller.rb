class OrderReceivesController < ApplicationController
	before_filter :authenticate_user!, :except => []
	def index
		@bookings = Booking.includes(:user,:post).where('poster_id = ?', current_user.id).page(params[:page]).order("id desc").per_page(4)
	end

	def search_order_received_by_date
	    if params[:start_date].blank? || params[:end_date].blank?
	      redirect_to order_receives_path, alert: "Please Select Date"
	    elsif  params[:start_date] > params[:end_date]
	      redirect_to  order_receives_path, alert: "Start Date Cannot Be Greater"
	    elsif params[:start_date] == params[:end_date]
	      @bookings = Booking.includes(:user,:post).where("created_at >= ? and date(created_at) <= ? and poster_id = ?",params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    else
	      @bookings = Booking.includes(:user,:post).where("date(created_at) >= ? and date(created_at) <= ? and poster_id = ?", params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    end
	end

	def payments
		@bookings = Booking.get_payments(current_user,params[:page])
	end



	def cancel_popup
     @booking = Booking.find(params[:id])
  	end

  	 #Cancel booking from Poster side and all amount refund to Finder without deduction.
	 def cancel_booking

	    @booking = Booking.find(params[:id])
		amount = @booking.price
		Booking.booking_cancel(@booking)
		PaymentHistory.create(:name => "cancel", :booking_id => @booking.id)
	    flash[:notice] = "Booking is cancel & $#{amount} is refunded. "
	    redirect_to order_receives_path

	end


end
