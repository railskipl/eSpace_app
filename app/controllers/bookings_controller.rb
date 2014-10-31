class BookingsController < ApplicationController

	def new
		@booking = Booking.new
	end

	def create
		

        if params[:booking][:price]

          @amount = (params[:booking][:price]).to_f
          
          customer = Stripe::Customer.create(
            :email => params[:booking][:email],
            :card  => params[:stripe_card_token],
            :description => "Customer #{params[:booking][:email]}"
          )
          
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
            
            @month = charge[:card][:exp_month]
            @year = charge[:card][:exp_year]

            @cardinfo = { 
               "stripe_id" => charge[:id],
               "card_id" => charge[:card][:id],
               "card_last4" => charge[:card][:last4],
               "card_exp_month" => charge[:card][:exp_month],
               "card_exp_year" => charge[:card][:exp_year],
               "card_fingerprint" => charge[:card][:fingerprint],
               "card_country" => charge[:card][:country],
               "card_address_line1" => charge[:card][:address_line1],
               "card_address_line2" => charge[:card][:address_line2],
               "card_address_city" => charge[:card][:address_city],
               "card_address_state" => charge[:card][:address_state],
               "card_address_zip" => charge[:card][:address_city],
               "card_address_country" => charge[:card][:address_country],
               "card_customer" => charge[:card][:customer],
               "card_type" => charge[:card][:type],
               "card_captured" => charge[:captured],
               "card_paid" => charge[:paid],
               "card_balance_transaction" => charge[:balance_transaction]
            }

            session[:grades] = session[:grades].merge(@cardinfo)
            @grades = session[:grades]

            
            @subscription.stripe_customer_token = charge[:created]
            subscriber = params[:subscription][:email]
            addition_email = params[:addition_email]

            
            
            session[:anualpremium] = nil
            session[:grades] = nil
            redirect_to feedback_subscriptions_path, :notice => "Thank you for choosing Bernard Fleischer & Sons, Inc."
          
        else
          render :new
          flash[:notice] = "Something went wrong,please try again. "
        end
      else
        flash[:notice] = "Session is clear, Please try again."
        redirect_to :back
      end
    

	end

	def checkout
		
		session[:price] = params[:booking][:price]
        session[:user_id] = params[:booking][:user_id] 
       
        redirect_to new_booking_path
	end

end
