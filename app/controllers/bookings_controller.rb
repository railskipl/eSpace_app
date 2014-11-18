class BookingsController < ApplicationController
 before_filter :authenticate_user!, :except => []
 include BookingsHelper

 def index
 	@bookings = Booking.where("user_id = ? AND is_cancel = ?",current_user.id,false)
 end

	def new
		@booking = Booking.new
	end

   def show
  @booking = Booking.find(params[:id])
  @post = Post.find(params[:id])
  @comments = Comment.where(:post_id => @post)
  end

	def create
        if session[:price] != nil
          @booking = Booking.new(page_params)
          @amount = (params[:booking][:price]).to_f
          begin
            customer = Stripe::Customer.create(
              :email => params[:booking][:email],
              :card  => params[:stripe_card_token],
              :description => "Customer #{params[:booking][:email]}"
            )
          rescue Stripe::InvalidRequestError => e
            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
            return false
          end
          
          if is_number?(@amount.to_f)
            @amount = ((@amount.to_f)*100).to_i

            charge = Stripe::Charge.create(
              :customer    => customer.id,
              :amount      => @amount,
              :description => "Charge for #{params[:booking][:email]}, Booking of price #{params[:booking][:price]}.",
              :currency    => 'usd'
            )
            
          end

          
          if charge[:id] && charge[:captured] == true
            
            @booking.stripe_customer_token = charge[:created]
            @booking.stripe_charge_id = charge[:id]
            @booking.save
            
            session[:price] = nil
            session[:post_id] = nil
            session[:poster_id] = nil
            redirect_to root_path, :notice => "Thank you"
          
        else
          render :new
          flash[:notice] = "Something went wrong,please try again. "
        end
      else
        flash[:notice] = "Session expired."
        redirect_to :back
      end
	end

def search_by_date
 @bookings = Booking.where("user_id = ? AND is_cancel = ?",current_user.id,false)
 if params[:start_date].blank? || params[:end_date].blank?
      redirect_to bookings_path, alert: "Please Select Date"
 elsif  params[:start_date] > params[:end_date]
      redirect_to  bookings_path, alert: "Start Date Cannot Be Greater"
  elsif params[:start_date] == params[:end_date]
    @bookings = @bookings.where("created_at >= :start_date and date(created_at) <= :end_date", {:start_date => params[:start_date], :end_date => params[:end_date]})
  else

    @bookings = @bookings.where("date(created_at) >= :start_date AND date(created_at) <= :end_date", {:start_date => params[:start_date], :end_date => params[:end_date]})
end

end

	def checkout
   	session[:price] = params[:booking][:price]
    session[:post_id] = params[:booking][:post_id] 
    session[:poster_id] = params[:booking][:poster_id]
    session[:dropoff_date] = params[:booking][:posting_dropoff_date]
    session[:dropoff_price] = params[:booking][:price]
    redirect_to new_booking_path
	end

  #this method cancel's the booking done by finder & does the cancel_booking_deduction
  # according to criteria.
  def cancel_booking
    @booking = Booking.where("id = ?",params[:id])
    @price = @booking.first.dropoff_price
    @stripe_charge_id = @booking.first.stripe_charge_id
    @days_diff =  days_diff(params[:drop_off_date].to_date)
    @amount = cancel_booking_deduction(@days_diff,@price).to_i 
    @amount_cents = ((@amount.to_f)*100).to_i

    begin
    ch = Stripe::Charge.retrieve(@stripe_charge_id) 
    refund = ch.refunds.create(:amount => @amount_cents)
    cancel_booking = @booking.first.update_columns(is_cancel: true)
    rescue Stripe::InvalidRequestError => e
            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
            return false
    end
    redirect_to new_booking_path
    flash[:notice] = "Booking is cancel & $#{@amount} is refunded. "
  end

	def is_number?(i)
    	true if Float(i) rescue false
  	end


private
	def page_params
      params.require(:booking).permit(:stripe_customer_token, :price, :user_id, :email, :post_id, :poster_id,:dropoff_date,:dropoff_price,:cut_off_price)
    end

end
