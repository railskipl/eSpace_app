class PayementTransfersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user, :only => [:index, :transfer_money, :search_payments, :check_status]

  layout 'admin'
  include PostsHelper

  def index
  	 @bookings = Booking.admin_payments(params[:page])

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

    @recipient_details = BankDetail.where("user_id =?", params[:poster_id]).first

      @booking = Booking.find(params[:booking_id])

    if @recipient_details

      @price = @booking.price.to_i
        data = PaymentTransfer.transfer_money_to_poster(@booking,@recipient_details)
        if data.class == Stripe::InvalidRequestError
         redirect_to :back, :notice => "Stripe error: #{data.message}"
        else
          redirect_to payement_transfers_path
          flash[:notice] = "Payement was successfully transfered to #{@recipient_details.stripe_card_id_token}. Amount transfer to poster $#{data[0]} and commision is $#{data[1]}"
       end
    else
      transfer_payment = @booking.update_columns(comment: "Waiting for poster bank account.")
      flash[:error]  = "No bank detail added for payment"
      redirect_to payement_transfers_path

    end
  end

  #Check's the transfer status from stripe api.
  def check_status
    @booking = Booking.find(params[:booking_id])
    @transfer_id = @booking.stripe_transfer_id
    tr = Stripe::Transfer.retrieve(@booking.stripe_transfer_id)
       if tr[:status] == "paid"
          transfer_payment = @booking.update_columns(status: tr[:status])
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
      @payment_transfers = Booking.where("date(created_at) >= ? and date(created_at) <= ? and on_hold = ?",@start_date, @end_date, false).order("id desc")
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
