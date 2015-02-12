class DisputesController < ApplicationController
	before_filter :authenticate_user!, :except => []
	before_filter :correct_user, :except => []
	before_action :set_booking, only: [:hold_money, :show, :refund_money_to_finder, :refund_finder, :charge_to_poster, :charged_to_poster]

	layout "admin"

	def index
  	 @disputes = Booking.hold_payments(params[:page])

      respond_to do |format|
        format.html
        format.xls
        format.pdf do
           render :pdf => "dispute_report"
        end
      end
  end

  def search
    @bookings = Booking.hold_payments(params[:page])
    if params[:search]
      @bookings = Booking.search_booking(params[:search])
    end
  end

  def hold
    @bookings = Booking.hold_payments(params[:page])
  end


  def show
  end

  def refund_money_to_finder
  end

  def send_money
    if params["_method"]
       price = params[:amount].to_i
       user = User.find(params[:id])
       stripe_recipient_token = user.bank_detail_stripe_recipient_token

        amount_cents = ((price)*100).to_i
      begin
      transfer = Stripe::Transfer.create(
      :amount => amount_cents, # amount in cents
      :currency => "usd",
      :recipient => stripe_recipient_token,
      :statement_description => "Money transfer"
      )
       rescue Stripe::InvalidRequestError => e
          redirect_to :back, :notice => "Stripe error: #{e.message}"
          return false
       end

      Dispute.create(:amount => price, :user_id => params[:id], :status => "send")
      flash[:notice] = "Money send"
      redirect_to search_user_disputes_path
    end
  end

  def refund_finder

    price = params[:amount].to_i

    stripe_charge_id = @booking.stripe_charge_id

    amount_cents = ((price)*100).to_i

  	begin

	    ch = Stripe::Charge.retrieve(stripe_charge_id)
	    refund = ch.refunds.create(:amount => amount_cents)
	  rescue Stripe::InvalidRequestError => e
	    redirect_to :back, :notice => "Stripe error: #{e.message}"
	    return false
	  end

	  Dispute.create(:amount => price, :booking_id => @booking.id, :user_id => params[:user_id], :status => "refund")

	  flash[:notice] = "Amount refunded"
	  redirect_to search_disputes_path(@booking.id)
  end


  def send_money_to_poster
  end

  def search_user
    @users = User.get_disputes.page(params[:page]).order("id desc").per_page(10)
    if params[:search]
      @search_user = User.find_by_email(params[:search])
    end
    respond_to do |format|
        format.html
        format.xls
        format.pdf do
           render :pdf => "Send/Charge"
        end
    end
  end


  def charge_money
  end

  def charged_money

  	price = params[:amount].to_i
    user = User.find(params[:id])
    stripe_customer_id =  user.bookings.last.try(:stripe_customer_id) || user.credit_card.try(:stripe_customer_id)
    amount_cents = ((price)*100).to_i

  	begin

	    charge = Stripe::Charge.create(
        :customer    => stripe_customer_id,
        :amount      => amount_cents,
        :description => "Charging #{price}.",
        :currency    => 'usd'
      )
	  rescue Stripe::InvalidRequestError => e
	    redirect_to :back, :notice => "Stripe error: #{e.message}"
	    return false
	  end

	  Dispute.create(:amount => price,  :user_id => params[:id], :status => "charge")

	  flash[:notice] = "Charged a money"
	  redirect_to search_user_disputes_path
  end

  def charge_to_poster
  end

  def charged_to_poster
    price = params[:amount].to_i

    stripe_customer_id = @booking.stripe_customer_id

    amount_cents = ((price)*100).to_i

    begin

      charge = Stripe::Charge.create(
        :customer    => stripe_customer_id,
        :amount      => amount_cents,
        :description => "Booking of price #{price}.",
        :currency    => 'usd'
      )
    rescue Stripe::InvalidRequestError => e
      redirect_to :back, :notice => "Stripe error: #{e.message}"
      return false
    end

    Dispute.create(:amount => price, :booking_id => @booking.id, :user_id => params[:user_id], :status => "charge")

    flash[:notice] = "Charged a money"
    redirect_to dispute_path(@booking.id)
  end



  def hold_money

	  @booking.on_hold = !@booking.on_hold?
	  @booking.save!

	  respond_to do |format|

      if params[:search]
	     format.html { redirect_to search_disputes_path, notice: 'Status updated.' }
      else
        format.html { redirect_to search_disputes_path, notice: 'Status updated.' }
      end
	    format.json { head :no_content }
	  end
  end


	private

	# Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end

end
