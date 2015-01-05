class DisputesController < ApplicationController
	before_filter :authenticate_user!, :except => []
	before_filter :correct_user, :except => []
	before_action :set_booking, only: [:hold_money, :show, :send_money_to_finder, :charge_to_finder, :charged_to_finder, :sent_to_finder, :send_money_to_poster, :charge_to_poster, :charged_to_poster]

	layout "admin"

	def index
  	 @disputes = Dispute.order("id desc")

      respond_to do |format|
        format.html
        format.xls
        format.pdf do
           render :pdf => "dispute_report"
        end
      end
  end

  def search

    @bookings = Booking.search_booking(params[:search])
  end


  def show
  end

  def send_money_to_finder
  end

  def sent_to_finder

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

	  flash[:notice] = "sending a money"
	  redirect_to dispute_path(@booking.id)
  end


  def send_money_to_poster
  end


  def charge_to_finder
  end
  	
  def charged_to_finder

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

	    format.html { redirect_to search_disputes_path(:search => params[:search]), notice: 'Status updated.' }
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