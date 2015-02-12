class Booking < ActiveRecord::Base
  include CancelBooking

  belongs_to :post
  belongs_to :poster,:class_name => 'User'
  belongs_to :user
  has_many :disputes, :dependent => :destroy
  has_many :payment_histories, :dependent => :destroy
  delegate :name, :last_name, :email, :to => :user, :prefix => true
  delegate :name, :last_name, :email, :provider,:user_id ,:to => :poster, :prefix => true
  delegate :address, :street_add, :apt, :city, :state, :zip_code, :area,:additional_comments, :user_id,
           :drop_off_avaibility_end_date, :pick_up, :drop_off, :drop_off_avaibility_start_date,
           :pick_up_avaibilty_start_date, :price_sq_ft, :pick_up_avaibility_end_date, :to => :post, :prefix => true

  scope :for_user, -> (user) { where('poster_id = :user_id or user_id = :user_id', user_id: user.id ) }
  scope :not_canceled, -> {where(is_cancel: false)}

  def self.get_payments(current_user,page_no)
    includes(:poster, :user).joins(:payment_histories).select_data.for_user(current_user).pagination(page_no)
  end

  def self.get_bookings(user,value)
    includes(:post,:poster).where("user_id = ? AND is_cancel = ?",user.id,value)
  end

  def self.start_and_end_date(start_date,end_date)
    where("created_at >= :start_date and date(created_at) <= :end_date", {:start_date => start_date, :end_date => end_date})
  end

  def self.admin_payments(page_no)
    includes(:poster,:post).order("id desc").where("on_hold= false").page(page_no).per_page(50)
  end

  def self.hold_payments(page_no)
    includes(:poster,:post).order("id desc").where("on_hold= true").page(page_no).per_page(50)
  end

  def self.select_data
    select("bookings.*,payment_histories.name,payment_histories.created_at as transaction_date")
  end

  def self.pagination(page_no)
    page(page_no).order("id desc").per_page(6)
  end

  # booking cancel by poster
  def self.booking_cancel(booking)
    amount = booking.price

    stripe_charge_id = booking.stripe_charge_id
    amount_cents = ((amount.to_f)*100).to_i

    begin
    ch = Stripe::Charge.retrieve(stripe_charge_id)
    ch.refunds.create(:amount => amount_cents)
    booking.update_attributes(is_cancel: true, refund_finder: amount, comment: "Cancel by poster.")
    Post.add_area(booking)
    rescue Stripe::InvalidRequestError => e
      return e
    end
      Message.create(:sender_id => booking.user_id, :recipient_id => booking.poster_id,
                     :post_id => booking.post_id,:body => "Booking is cancel")
  end

  def self.search_booking(search)
    search ? includes(:poster,:post).where('id = ?', search).order("id desc") : []
  end

  # Booking cancel by finder
  def self.booking_cancel_finder(booking, date)
    price = booking.price
    stripe_charge_id = booking.stripe_charge_id
    days_diff =  days_diff(date)

    if price <= GlobalConstants::BOOKING_AMOUNT
      amount = cancel_booking_by_finder_less8(days_diff, price)
      send_money = (price.to_f - GlobalConstants::ADMIN_COMISSION) - amount
    else
      amount = cancel_booking_deduction(days_diff, price)
      send_money = send_money_to_poster(days_diff, price)
    end
    send_money_cents = (send_money * GlobalConstants::CENTS).to_i
    amount_cents = (amount * GlobalConstants::CENTS).to_i
    refund_addition = amount * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1

    begin
      ch = Stripe::Charge.retrieve(stripe_charge_id)
      ch.refunds.create(amount: amount_cents)
    rescue Stripe::InvalidRequestError => e
      return e
    end

    recipient_details = BankDetail.where("user_id =?", booking.poster_id).first
    mod_price = price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE_ALL
    mod_send_money = send_money + GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
    commission = price.to_i - mod_price - mod_send_money - amount - refund_addition
    stripe_processing_fees = mod_price - refund_addition
    money_to_admin = send_money_to_admin(days_diff, price) - stripe_processing_fees

    if recipient_details.present?
      commission = price <= GlobalConstants::BOOKING_AMOUNT ? commission : money_to_admin
      begin
        Stripe::Transfer.create(
          :amount => send_money_cents, # amount in cents
          :currency => "usd",
          :recipient => recipient_details.stripe_recipient_token,
          :card => recipient_details.stripe_card_id_token,
          :statement_descriptor => "Money transfer"
        )
      rescue Stripe::InvalidRequestError => e
        return e
      end
      booking.update_attributes(cut_off_price: send_money, commission: commission)
      return amount

    else
      if price <= GlobalConstants::BOOKING_AMOUNT
        commission = commission + send_money
      else
        commission = money_to_admin - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT + send_money
      end
      booking.update_attributes(commission: commission, comment: "Waiting for poster bank account.")
      return amount
    end
  end

end
