class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user

	scope :booking_cancelled, -> {where(is_cancel: true)}

	delegate :name, :last_name ,:to => :user, :prefix => true
	delegate :name, :last_name, :provider,:user_id ,:to => :poster, :prefix => true
	delegate :address, :street_add, :apt, :city, :state, :zip_code, :area,:additional_comments, 
			 :drop_off_avaibility_end_date, :pick_up, :drop_off, :drop_off_avaibility_start_date,
			 :pick_up_avaibilty_start_date, :price_sq_ft, :pick_up_avaibility_end_date, :to => :post, :prefix => true

	# def self.result_area(post)
	# 	select("area").where("post_id = ? and pickup_date >= ? and is_cancel != ?", post.id, Date.today, true)
	# end

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

	      message_params = {}
	      message_params["sender_id"] = booking.user_id
	      message_params["recipient_id"] = booking.poster_id
	      message_params["post_id"] = booking.post_id
	      message_params["body"] = "Booking is cancel"
	      message = Message.new(message_params)
	      message.save

	end
end
