class PaymentTransfer
  include ActiveModel::Validations
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

        if @price <= 8
          received_by_poster = (@price - 0.80) - 0
          total_amount = (received_by_poster * 100).to_i
          stripe_processing_fees = booking.price.to_i * 0.029 + 0.30
          commission = @price - stripe_processing_fees - (received_by_poster + 0.25)
        else
          received_by_poster = @price - processing_fees(@price)
          stripe_processing_fees = booking.price.to_i * 0.029 + 0.30
          commission = processing_fees(@price) - stripe_processing_fees - 0.25
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
end