class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user
	include CancelBooking
	has_many :disputes, :dependent => :destroy
	has_many :payment_histories, :dependent => :destroy
	delegate :name, :last_name, :email, :to => :user, :prefix => true
	delegate :name, :last_name, :email, :provider,:user_id ,:to => :poster, :prefix => true
	delegate :address, :street_add, :apt, :city, :state, :zip_code, :area,:additional_comments, :user_id,
			 :drop_off_avaibility_end_date, :pick_up, :drop_off, :drop_off_avaibility_start_date,
			 :pick_up_avaibilty_start_date, :price_sq_ft, :pick_up_avaibility_end_date, :to => :post, :prefix => true

	# def self.result_area(post)
	# 	select("area").where("post_id = ? and pickup_date >= ? and is_cancel != ?", post.id, Date.today, true)
	# end
	def self.get_payments(current_user,page_no)
	  includes(:poster, :user).joins(:payment_histories).select_data.fetch_data(current_user).pagination(page_no)
	end

	def self.hide_cancelled(user_id)
	  where("user_id = ? AND is_cancel = ?", user_id, false)
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

	# def self.admin_disputes(page_no)
	#   includes(:poster, :user).joins(:disputes).select("bookings.*, disputes.amount, disputes.status").page(page_no).per_page(50)
	# end

	def self.select_data
		select("bookings.*,payment_histories.name,payment_histories.created_at as transaction_date")
	end

	scope :fetch_data, -> (current_user) { where('poster_id = ? or user_id = ?', current_user.id, current_user.id ) }

	def self.pagination(page_no)
		page(page_no).order("id desc").per_page(6)
	end

	#booking cancel by poster
	def self.booking_cancel(booking)
		amount = booking.price

	    stripe_charge_id = booking.stripe_charge_id
	    amount_cents = ((amount.to_f)*100).to_i

	    begin
	    ch = Stripe::Charge.retrieve(stripe_charge_id)
	    refund = ch.refunds.create(:amount => amount_cents)
	    booking.update_attributes(is_cancel: true, refund_finder: amount, comment: "Cancel by poster.")
	    Post.add_area(booking)
	    rescue Stripe::InvalidRequestError => e
	      return e
	    end
        Message.create(:sender_id => booking.user_id, :recipient_id => booking.poster_id,
	      				 :post_id => booking.post_id,:body => "Booking is cancel")
	end

	def self.search_booking(search)
		if search
		    includes(:poster,:post).where('id = ?', search).order("id desc")
		else
		    []
		end
	end

	#Booking cancel by finder
	def self.booking_cancel_finder(booking,dt)
		price = booking.price
	    stripe_charge_id = booking.stripe_charge_id
	    days_diff =  days_diff(dt)

	    if price <= GlobalConstants::BOOKING_AMOUNT
	      amount = cancel_booking_by_finder_less8(days_diff, price)
	      refund_addition = amount * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1
	      amount_cents = ((amount)*GlobalConstants::CENTS).to_i
	      send_money = (price.to_f - GlobalConstants::ADMIN_COMISSION) - amount
	      send_money_cents = ((send_money)*GlobalConstants::CENTS).to_i
	    else
	      amount = cancel_booking_deduction(days_diff, price)
	      amount_cents = ((amount)*GlobalConstants::CENTS).to_i
	      refund_addition = amount * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1
	      send_money = send_money_to_poster(days_diff, price)
	      send_money_cents = ((send_money)*GlobalConstants::CENTS).to_i
	    end

	    begin
	      ch = Stripe::Charge.retrieve(stripe_charge_id)
	      refund = ch.refunds.create(:amount => amount_cents)
	      cancel_booking = booking.update_columns(is_cancel: true)
	    rescue Stripe::InvalidRequestError => e
	      return e
	    end

	    recipient_details = BankDetail.where("user_id =?", booking.poster_id).first

	    if recipient_details.present?

	      if price <= GlobalConstants::BOOKING_AMOUNT
	        commission = (price.to_i - (price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2)) - (send_money + GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT) - (amount - refund_addition)
	      else
	        stripe_processing_fees = price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2 - refund_addition
	        commission = send_money_to_admin(days_diff, price) - stripe_processing_fees
	      end

	      begin
	        transfer = Stripe::Transfer.create(
	        :amount => send_money_cents, # amount in cents
	        :currency => "usd",
	        :recipient => recipient_details.stripe_recipient_token,
	        :card => recipient_details.stripe_card_id_token,
	        :statement_description => "Money transfer"
	      )
	       rescue Stripe::InvalidRequestError => e
	          return e
	       end

	       transfer_payment = booking.update_attributes(cut_off_price: send_money,commission: commission)
	       return amount
	    else

	      if price <= GlobalConstants::BOOKING_AMOUNT
	        commission = (price.to_i - (price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2)) - (send_money + GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT) - (amount - refund_addition) + send_money
	      else
	       stripe_processing_fees = price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2 - refund_addition
	       commission = send_money + send_money_to_admin(days_diff, price) - stripe_processing_fees - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
	      end
	       transfer_payment = booking.update_attributes(commission: commission,comment: "Waiting for poster bank account.")
	       return amount
	    end
	end

end
