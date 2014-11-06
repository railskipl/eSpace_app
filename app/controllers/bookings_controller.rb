class BookingsController < ApplicationController
 before_filter :authenticate_user!, :except => []
 def index
 	
 end
	def new
		@booking = Booking.new
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


	def checkout
		session[:price] = params[:booking][:price]
    session[:post_id] = params[:booking][:post_id] 
    session[:poster_id] = params[:booking][:poster_id]
    redirect_to new_booking_path
	end

	def is_number?(i)
    	true if Float(i) rescue false
  	end


private
	def page_params
      params.require(:booking).permit(:stripe_customer_token, :price, :user_id, :email, :post_id)
    end

end
