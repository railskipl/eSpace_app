class PayementTransfersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user, :only => [:index, :transfer_money, :search_payments, :check_status]

  layout 'admin'
  include PostsHelper

  
  def index
  	 @bookings = Booking.includes(:poster,:post)
  end
  
  #transfer the payement to poster account. 
  def transfer_money
    @recipient_details = BankDetail.where("user_id =?",params[:poster_id]).first
    if @recipient_details
      @booking = Booking.where("id = ?",params[:booking_id])

      @price = @booking.first.price.to_i
      @price = @price - processing_fees(@price)
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
      transfer_payment = @booking.first.update_columns(cut_off_price: @price)

      redirect_to payement_transfers_path
      flash[:notice] = "Payement was successfully transfered to #{@recipient_details.stripe_card_id_token}. Amount transfer to poster $#{@price}"
    else
      redirect_to payement_transfers_path
      flash[:error]  = "No bank detail added for payment"
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
      @payment_transfers = Booking.where("date(created_at) >= ? and date(created_at) <= ?",@start_date, @end_date) 
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
