class BookingsController < ApplicationController
 before_filter :authenticate_user!, :except => []
 skip_before_filter :verify_authenticity_token, :only => [:checkout]

 include BookingsHelper

 def index
    if params[:cancelled].present?
      @bookings = Booking.includes(:post,:poster).hide_cancelled(current_user.id).page(params[:page]).per_page(4)
    else
 	    @bookings = Booking.includes(:post,:poster).page(params[:page]).where("user_id = ?",current_user.id).order("id desc").per_page(4)
    end
 end

	def new
		@booking = Booking.new
	end

  def show
    @booking = Booking.find(params[:id])
    @post = Post.find(@booking.post_id)

  end

	def create


	end

  def search_by_date
    bookings = Booking.get_bookings(current_user,false)
    if params[:start_date].blank? || params[:end_date].blank?
      redirect_to bookings_path, alert: "Please Select Date"
    elsif  params[:start_date].to_date > params[:end_date].to_date
      redirect_to  bookings_path, alert: "Start Date Cannot Be Greater"
    elsif params[:start_date] == params[:end_date]
      @bookings = bookings.start_and_end_date(params[:start_date].to_date,params[:end_date].to_date)
    else
      @bookings = bookings.start_and_end_date(params[:start_date].to_date,params[:end_date].to_date)
    end

  end


  #Checkout Stripe payment
	def checkout

   	if params[:totalPrice] != nil

      dropoff_date = params[:booking][:dropoff_date].to_date rescue nil
      pickup_date = params[:booking][:pickup_date].to_date rescue nil
      price = (params[:totalPrice].to_i)/100

      @amount = (params[:totalPrice]).to_f

      begin
        customer = Stripe::Customer.create(
          :email => params[:stripeEmail],
          :card  => params[:stripeToken],
          :description => "Customer #{params[:stripeEmail]}"
        )
      rescue Stripe::InvalidRequestError => e
        redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}"
        return false
      end

      if is_number?(@amount.to_f)
        @amount = ((@amount.to_f)).to_i
        charge = Stripe::Charge.create(
            :customer    => customer.id,
            :amount      => @amount,
            :description => "Charge for #{params[:stripeEmail]}, Booking of price #{price}.",
            :currency    => 'usd'
          )
      end

      if charge[:id] && charge[:captured] == true
        booking = Booking.create(:stripe_customer_token => charge[:created], :price => price,
                                 :post_id => params[:booking][:post_id],:user_id => current_user.id,
                                 :poster_id => params[:booking][:poster_id], :email => params[:stripeEmail],
                                 :area => params[:area], :dropoff_date => dropoff_date,
                                 :dropoff_price => params[:dropoff_price], :pickup_date => pickup_date,
                                 :pickup_price => params[:pickup_price], :stripe_charge_id => charge[:id],
                                 :stripe_customer_id => customer.id)
        Post.substract_area(booking)
        PaymentHistory.create(:name => "created", :booking_id => booking.id)
        BookedMailer.booked_a_spaces(booking).deliver
        redirect_to bookings_path, :notice => "Thank you"
      else
        render :new
        flash[:notice] = "Something went wrong,please try again. "
      end
    else
        flash[:notice] = "Session expired."
        redirect_to :back
    end
	end


  def cancel_popup
     @booking = Booking.find(params[:id])
  end

  #this method cancel's the booking done by finder & does the cancel_booking_deduction
  # according to criteria.
  def cancel_booking
    @booking = Booking.find(params[:id])
    data = Booking.booking_cancel_finder(@booking,params[:drop_off_date].to_date)
    if data.class == Stripe::InvalidRequestError
      redirect_to :back, :notice => "Stripe error: #{data.message}"
    else
      Message.create(:sender_id =>  @booking.user_id, :recipient_id => @booking.poster_id,
                     :post_id => @booking.post_id,:body => "Booking is cancel")
      transfer_payment = @booking.update_columns(refund_finder: data)
      Post.add_area(@booking)
      PaymentHistory.create(:name => "cancel", :booking_id => @booking.id)
      flash[:notice] = "Booking is cancel & $#{data} is refunded"
      redirect_to booking_path(@booking.id)
    end
  end


  def rating
    @post = Post.find(params[:post_id])
  end

  def drop_off
    @booking = Booking.find(params[:booking_id])
  end

  def confirm
    booking = Booking.find(params[:id])
    booking.is_confirm = true
    booking.save
    Message.create(:sender_id => booking.user_id, :recipient_id => booking.poster_id,
                 :post_id => booking.post_id,:body => "Drop-off has been confirmed.")
    if params["index"]
      redirect_to bookings_path
    else
      redirect_to booking_path(booking.id)
    end
    flash[:notice] = "Confirm drop off"

  end


	def is_number?(i)
    	true if Float(i) rescue false
  end


end
