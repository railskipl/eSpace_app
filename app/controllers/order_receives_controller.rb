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
	      @bookings = Booking.where("created_at >= ? and date(created_at) <= ? and poster_id = ?",params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    else
	      @bookings = Booking.where("date(created_at) >= ? and date(created_at) <= ? and poster_id = ?", params[:start_date].to_date, params[:end_date].to_date,current_user.id)
	    end
	end

	def payments
		@bookings = Booking.includes(:user).where('poster_id = ? or user_id = ?', current_user.id, current_user.id )
	    
	end

	

	def cancel_popup
     @booking = Booking.find(params[:id])
  	end

  	 #Cancel booking from Poster side and all amount refund to Finder without deduction.
	 def cancel_booking

	    @booking = Booking.find(params[:id])
	
	    amount = @booking.price
	    
	    stripe_charge_id = @booking.stripe_charge_id
	    amount_cents = ((amount.to_f)*100).to_i

	    begin
	    ch = Stripe::Charge.retrieve(stripe_charge_id) 
	    refund = ch.refunds.create(:amount => amount_cents)
	    cancel_booking = @booking.update_columns(is_cancel: true)
	    transfer_payment = @booking.update_columns(refund_finder: amount)
	    cancel_booking = @booking.update_columns(comment: "Cancel by poster.")
	    
	    rescue Stripe::InvalidRequestError => e
	            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
	            return false
	    end

	      message_params = {}
	      message_params["sender_id"] = @booking.user_id
	      message_params["recipient_id"] = @booking.poster_id
	      message_params["post_id"] = @booking.post_id
	      message_params["body"] = "Booking is cancel"
	      message = Message.new(message_params)
	      message.save

	    flash[:notice] = "Booking is cancel & $#{amount} is refunded. "
	    redirect_to order_receives_path
	    
	end


end
