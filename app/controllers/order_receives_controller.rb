class OrderReceivesController < ApplicationController
	before_filter :authenticate_user!, :except => []
	before_action :set_order, only: [:cancel_popup, :cancel_booking]
	before_action :check_user_privilege, only: [:cancel_popup, :cancel_booking]


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
  	end

  	 #Cancel booking from Poster side and all amount refund to Finder without deduction.
	 def cancel_booking

		amount = @booking.price
		data = Booking.booking_cancel(@booking)
		if data.class == Stripe::InvalidRequestError
		  redirect_to :back, :notice => "Stripe error while creating customer: #{data.message}"
		else
		  PaymentHistory.create(:name => "cancel", :booking_id => @booking.id)
	      flash[:notice] = "Booking is cancel & $#{amount} is refunded. "
	      redirect_to order_receives_path
		end
	end


	private

	def set_order
      @booking = Booking.find(params[:id])
    end

	def check_user_privilege
      redirect_to order_receives_path, notice: 'Sorry, you are not allowed to access that page.' unless @booking.poster_id == current_user.id
    end


end
