class OrderReceivesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bookings = scope.page(params[:page]).order("id desc").per_page(4)
  end

  def search_order_received_by_date
    if params[:start_date].blank? || params[:end_date].blank?
      redirect_to order_receives_path, alert: "Please Select Date"
    elsif  params[:start_date] > params[:end_date]
      redirect_to order_receives_path, alert: "Start Date Cannot Be Greater"
    elsif params[:start_date] == params[:end_date]
      @bookings = scope.where("created_at >= ? and date(created_at) <= ?", params[:start_date].to_date, params[:end_date].to_date)
    else
      @bookings = scope.where("date(created_at) >= ? and date(created_at) <= ?", params[:start_date].to_date, params[:end_date].to_date)
    end
  end

  def payments
    @bookings = Booking.get_payments(current_user, params[:page])
  end

  def cancel_popup
    @booking = current_user.orders.find(params[:id])
  end

  # Cancel booking from Poster side and all amount refund to Finder without deduction.
  def cancel_booking
    @booking = current_user.orders.find(params[:id])
    post = current_user.orders.find(params[:id]).post
    data = Booking.booking_cancel_finder(@booking, @booking.dropoff_date.to_date)
    if data.class == Stripe::InvalidRequestError
      redirect_to :back, :notice => "Stripe error: #{data.message}"
    else
      Message.create(:sender_id =>  @booking.user_id, :recipient_id => @booking.poster_id,
                     :post_id => @booking.post_id,:body => "Booking is cancel")
      transfer_payment = @booking.update_columns(refund_finder: data)
      Post.add_area(@booking)
      PaymentHistory.create(:name => "cancel", :booking_id => @booking.id)
      flash[:notice] = "Booking is cancel & $#{data} is refunded"
      OrderMailer.order_status(@booking, post).deliver
      redirect_to order_receives_path
    end
  end

  private

  def scope
    current_user.orders.includes(:user, :post)
  end

end
