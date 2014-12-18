class BookingsController < ApplicationController
 before_filter :authenticate_user!, :except => []
 skip_before_filter :verify_authenticity_token, :only => [:checkout]
 include BookingsHelper

 def index
 	@bookings = Booking.includes(:post,:poster).where("user_id = ?",current_user.id).order("id desc")
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
    @bookings = Booking.where("user_id = ? AND is_cancel = ?",current_user.id,false)
    if params[:start_date].blank? || params[:end_date].blank?
      redirect_to bookings_path, alert: "Please Select Date"
    elsif  params[:start_date] > params[:end_date]
      redirect_to  bookings_path, alert: "Start Date Cannot Be Greater"
    elsif params[:start_date] == params[:end_date]
      @bookings = @bookings.where("created_at >= :start_date and date(created_at) <= :end_date", {:start_date => params[:start_date].to_date, :end_date => params[:end_date].to_date})
    else

    @bookings = @bookings.where("date(created_at) >= :start_date AND date(created_at) <= :end_date", {:start_date => params[:start_date].to_date, :end_date => params[:end_date].to_date})
    end

  end


  #Checkout Stripe payment
	def checkout
    
   	if params[:totalPrice] != nil

      dropoff_date = params[:booking][:dropoff_date].to_date rescue nil
      pickup_date = params[:booking][:pickup_date].to_date rescue nil
      
      booking = {}
      booking["stripe_customer_token"] = params[:stripeToken]
      booking["price"] = (params[:totalPrice].to_i)/100
      booking["post_id"] = params[:booking][:post_id]
      booking["user_id"] = current_user.id
      booking["poster_id"] = params[:booking][:poster_id]
      booking["email"] = params[:stripeEmail]
      booking["area"] = params[:area]
      booking["dropoff_date"] = dropoff_date
      booking["dropoff_price"] = params[:dropoff_price]
      booking["pickup_date"] = pickup_date
      booking["pickup_price"] = params[:pickup_price]

      
      @booking = Booking.new(booking)
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
            :description => "Charge for #{params[:stripeEmail]}, Booking of price #{booking["price"]}.",
            :currency    => 'usd'
          )

        end

          
        if charge[:id] && charge[:captured] == true
            
          @booking.stripe_customer_token = charge[:created]
          @booking.stripe_charge_id = charge[:id]
          @booking.save
            
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
    price = @booking.price


    stripe_charge_id = @booking.stripe_charge_id
    days_diff =  days_diff(params[:drop_off_date].to_date)
    amount = cancel_booking_deduction(days_diff, price).to_i 
    amount_cents = ((@amount.to_f)*100).to_i

    begin
    ch = Stripe::Charge.retrieve(stripe_charge_id) 
    refund = ch.refunds.create(:amount => amount_cents)
    cancel_booking = @booking.update_columns(is_cancel: true)
    rescue Stripe::InvalidRequestError => e
            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
            return false
    end

    flash[:notice] = "Booking is cancel & $#{amount} is refunded. "
    redirect_to booking_path(@booking.id)
    
  end


  def rating
    @post = Post.find(params[:post_id])
  end

  def drop_off
    @booking = Booking.find(params[:booking_id])
  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.update_columns(is_confirm: true)

    redirect_to booking_path(@booking.id)
    flash[:notice] = "Confirm drop off"

  end


	def is_number?(i)
    	true if Float(i) rescue false
  end


private
	def page_params
      params.require(:booking).permit(:stripe_customer_token, :price, :user_id, :email, :post_id, :poster_id,:dropoff_date,:dropoff_price,:cut_off_price)
    end

end
