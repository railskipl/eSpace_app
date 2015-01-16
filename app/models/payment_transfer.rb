class PaymentTransfer
	# Transfer money to Poster(Cronjob)
	def self.my_cron
		bookings = Booking.where("on_hold = ? and is_cancel = ? and dropoff_date = ? and stripe_transfer_id is ?", false, false, Date.today - 5.day, nil)

		bookings.each do |booking|
			recipient_details = BankDetail.where("user_id =?", booking.poster_id).first
		    if recipient_details
          PaymentTransfer.transfer_money_to_poster(booking,recipient_details)
		    else
		      transfer_payment = booking.update_columns(comment: "Waiting for poster bank account.")
		    end
		end
	end

	def self.transfer_money_to_poster(booking,recipient_details)
		@price = booking.price.to_i
        if @price <= GlobalConstants::BOOKING_AMOUNT
          received_by_poster = (@price - GlobalConstants::ADMIN_COMISSION)
          total_amount = (received_by_poster * GlobalConstants::CENTS).to_i
          stripe_processing_fees = booking.price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2
          commission = @price - stripe_processing_fees - (received_by_poster + GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT)
        else
          received_by_poster = @price - processing_fees(@price)
          stripe_processing_fees = booking.price.to_i * GlobalConstants::STRIPE_COMISSION_FOR_CHARGE1 + GlobalConstants::STRIPE_COMISSION_FOR_CHARGE2
          commission = processing_fees(@price) - stripe_processing_fees - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
          total_amount = ((received_by_poster) * GlobalConstants::CENTS).to_i
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
            # redirect_to :back, :notice => "Stripe error while creating customer: #{e.message}"
            return e
         end

        transfer_payment = booking.update_attributes(stripe_transfer_id: transfer[:id],
        status: 'Paid',
        is_confirm: true,
        cut_off_price: received_by_poster,
        commission: commission)

        #transfer_payment = booking.update_attributes(person_params)
        PaymentHistory.create(:name => "transfered", :booking_id => booking.id)
        message_params = {}
        message_params["sender_id"] = User.find_by(:admin => true).id
        message_params["recipient_id"] = booking.poster_id
        message_params["body"] = "Payment has been transfered to your account."
        message = Message.new(message_params)
        message.save
        return received_by_poster,commission
	end

  def self.processing_fees(fees)
   if fees <= GlobalConstants::BOOKING_AMOUNT
    @cut_off = fees.to_f * GlobalConstants::ADMIN_COMISSION
    return @cut_off
   elsif fees > GlobalConstants::BOOKING_AMOUNT
     @cut_off = fees.to_f * 10/100
     return @cut_off
   end
  end

end