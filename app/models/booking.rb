class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user
	has_many :disputes, :dependent => :destroy
	has_many :payment_histories, :dependent => :destroy
	scope :booking_cancelled, -> {where(is_cancel: true)}

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
	            redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
	            return false
	    end


	      Message.create(:sender_id => booking.user_id, :recipient_id => booking.poster_id, 
	      				 :post_id => booking.post_id,:body => "Booking is cancel")
	      

	end


	# Transfer money to Poster(Cronjob)
	def self.my_cron
		bookings = Booking.where("on_hold = ? and is_cancel = ? and dropoff_date = ? and stripe_transfer_id is ?", false, false, Date.today - 5.day, nil)

		bookings.each do |booking|

			recipient_details = BankDetail.where("user_id =?", booking.poster_id).first

		    if recipient_details

		      price = booking.price.to_i

			      if price <= 8
			        received_by_poster = (price - 0.80) - 0
			        total_amount = (received_by_poster * 100).to_i
			        stripe_processing_fees = booking.price.to_i * 0.029 + 0.30
			        commission = price - stripe_processing_fees - (received_by_poster + 0.25)
			      else
			      	
			      	processing_fees = price.to_f * 10/100
			        received_by_poster = price - processing_fees
			        stripe_processing_fees = booking.price.to_i * 0.029 + 0.30
			        commission = processing_fees - stripe_processing_fees - 0.25
			        total_amount = ((received_by_poster) * 100).to_i
			      end

			    begin
			      transfer = Stripe::Transfer.create(
			  	  :amount => total_amount, # amount in cents
			  	  :currency => "usd",
			  	  :recipient => recipient_details.stripe_recipient_token,
			  	  :card => recipient_details.stripe_card_id_token,
			  	  :statement_description => "Money transfer"
			  	)
			     rescue Stripe::InvalidRequestError => e
			        redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}" 
			        return false
			     end

			      transfer_payment = booking.update_attributes(stripe_transfer_id: transfer[:id], 
			      status: 'Paid',
			      is_confirm: true,
			      cut_off_price: received_by_poster,
			      commission: commission)
		      
		      
			      PaymentHistory.create(:name => "transfered", :booking_id => booking.id)
			      message_params = {}
			      message_params["sender_id"] = 1
			      message_params["recipient_id"] = booking.poster_id
			      message_params["post_id"] = booking.post_id
			      message_params["body"] = "Payment has been transfered to your account."
			      message = Message.new(message_params)
			      message.save

		    else
		      transfer_payment = booking.update_columns(comment: "Waiting for poster bank account.")
		    end
		end


	end

	


	def self.search_booking(search)
		if search
		    includes(:poster,:post).where('id = ?', search).order("id desc")
		else
		    []
		end
	end

end
