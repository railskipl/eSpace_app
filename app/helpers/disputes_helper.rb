module DisputesHelper


	def charge_user(user)
		if user.bookings.last.try(:stripe_customer_id) || user.credit_card
			link_to "Charge" ,charge_money_dispute_path(user) 
		else
			"No Bank Detail Provided"  
		end
	end

	def send_user(user)
		if user.bank_detail
			link_to "Send" ,send_money_dispute_path(user) 
		else
			"No Bank Detail Provided"
		end
	end

	def change_status(booking)
      dispute = get_refund_data(booking)

	  if dispute.present? && dispute.status == "refund"
	  	"UnHold"
	  elsif !booking.stripe_transfer_id.nil?
	  	"-"
	  else
		link_to (booking.on_hold? ? 'UnHold' : 'Hold'), hold_money_dispute_path(booking, :search=> params[:search])
	  end
	end


	def check_disputes(booking, user) 
	    if user == 'finder'
		   	dispute = get_refund_data(booking)

	   	    if dispute.present? && dispute.status == "refund"
	   		   "Already refunded"
	   		elsif !booking.on_hold
	   			"-"
	   		else
	   	   	   "#{link_to "Refund ", refund_money_to_finder_dispute_path(booking)}".html_safe
	   		end
	    end
	end

	def get_refund_data(booking)
		Dispute.select("status,amount").find_by_booking_id_and_user_id_and_status(booking.id, booking.user_id,"refund")
	end

	def net_charge(booking,amount)
		if !amount.nil?
			if booking.price == amount
				0
			elsif booking.price > amount
				booking.price - amount
			end
		end
	end
	
	def stripe_commission(booking,amount)
		if !amount.nil?
			if booking.price == amount
				0
			elsif booking.price > amount
				net_amt = booking.price - amount
				net_amt = net_amt*0.029 + 0.30
			end
		end
	end
	
	def balance(booking,amount)
		if !amount.nil?
			if booking.price == amount
				0
			elsif booking.price > amount
				net_amt = booking.price - amount
				net_amt = net_amt - (net_amt*0.029 + 0.30)
			end
		end
	end
end
