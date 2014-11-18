class PayementTransfersController < ApplicationController
  def index
  	 @bookings = Booking.all
  end
  
  #transfer the payement to poster account. 
  def transfer_money
    @recipient_details = BankDetail.where("user_id =?",params[:poster_id]).first
    @booking = Booking.where("id = ?",params[:booking_id])
    @price = @booking.first.dropoff_price.to_i
    begin
    transfer = Stripe::Transfer.create(
	  :amount => @price * 100, # amount in cents
	  :currency => "usd",
	  :recipient => @recipient_details.stripe_recipient_token,
	  :card => @recipient_details.stripe_card_id_token,
	  :statement_description => "Money transfer"
	)
   rescue Stripe::InvalidRequestError => e
            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
            return false
   end
    transfer_payment = @booking.first.update_columns(stripe_transfer_id: transfer[:id])
    transfer_payment = @booking.first.update_columns(status: transfer[:status])
    redirect_to payement_transfers_path
    flash[:notice] = "Payement was successfully transfered to #{@recipient_details.stripe_card_id_token}. "
  end	
  
  #Check's the transfer status from stripe api.
  def check_status
    @booking = Booking.where("id = ?",params[:booking_id])
    @transfer_id = @booking.first.stripe_transfer_id
    tr = Stripe::Transfer.retrieve(@booking.first.stripe_transfer_id)
       if tr[:status] == "paid"
          transfer_payment = @booking.first.update_columns(status: tr[:status]) 
          redirect_to payement_transfers_path 
          flash[:notice] = "Payment was Transfered."
       else 
         flash[:notice] = "Payment Transfer is Pending."
         redirect_to payement_transfers_path  
       end  

  end  
  

end
