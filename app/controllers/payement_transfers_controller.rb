class PayementTransfersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user, :only => [:index, :transfer_money, :search_payments, :check_status]

  layout 'admin'
  include PostsHelper

  
  def index
  	 @bookings = Booking.includes(:poster,:post).order("id desc")

     respond_to do |format|
        format.html
        format.xls
          format.pdf do
          render :pdf => "payments_report"
          end   
      end

  end
  
  #transfer the payement to poster account. 
  def transfer_money
    @recipient_details = BankDetail.where("user_id =?",params[:poster_id]).first

      @booking = Booking.where("id = ?",params[:booking_id])

    if @recipient_details

      @price = @booking.first.price.to_i

      if @price <= 8
        received_by_poster = (@price - 0.80) - 0
        total_amount = (received_by_poster * 100).to_i
        stripe_processing_fees = @booking.first.price.to_i * 0.029 + 0.30
        commission = @price - stripe_processing_fees - (received_by_poster + 0.25)
      else
        received_by_poster = @price - processing_fees(@price)
        stripe_processing_fees = @booking.first.price.to_i * 0.029 + 0.30
        commission = processing_fees(@price) - stripe_processing_fees - 0.25
        total_amount = ((received_by_poster) * 100).to_i
      end

    begin
      transfer = Stripe::Transfer.create(
  	  :amount => total_amount, # amount in cents
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
      transfer_payment = @booking.first.update_columns(is_confirm: true)
      transfer_payment = @booking.first.update_columns(cut_off_price: received_by_poster)
      transfer_payment = @booking.first.update_columns(commission: commission)
      
      #transfer_payment = @booking.update_attributes(person_params)

      message_params = {}
      message_params["sender_id"] = current_user.id
      message_params["recipient_id"] = @booking.first.poster_id
      message_params["post_id"] = @booking.first.post_id
      message_params["body"] = "Payment has been transfered to your account."
      message = Message.new(message_params)
      message.save


      redirect_to payement_transfers_path
      flash[:notice] = "Payement was successfully transfered to #{@recipient_details.stripe_card_id_token}. Amount transfer to poster $#{received_by_poster} and commision is $#{commission}"
    else
      transfer_payment = @booking.first.update_columns(comment: "Waiting for poster bank account.")
      flash[:error]  = "No bank detail added for payment"
      redirect_to payement_transfers_path
      
    end
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

  def search_payments
    @start_date = "#{params['start_date']}"
    @end_date ="#{params['end_date']}"

    if @start_date.blank? || @end_date.blank?
      flash[:error] = "Please Select Date"
      return false
    elsif @start_date > @end_date
      flash[:error] = "Start Date Cannot Be Greater"
      # return false
    else
      @payment_transfers = Booking.where("date(created_at) >= ? and date(created_at) <= ?",@start_date, @end_date).order("id desc")
    end
        respond_to do |format|
        format.html
        format.xls
          format.pdf do
          render :pdf => "payments_report"
          end   
        end
  end

  private

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end
  

end
