module DisputesHelper


	def charge_user(user)
		if user.bookings.last.try(:stripe_customer_id)
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


	def check_disputes(booking_id, user_id, user) 
	 
    if user == 'finder'
	   	dispute = Dispute.select("status").find_by_booking_id_and_user_id_and_status(booking_id, user_id,"refund")

   	    if dispute.present? && dispute.status == "refund"
   		   "Already refunded"
   		else
   	   	   "#{link_to "Refund ", refund_money_to_finder_dispute_path(booking_id)}".html_safe
   		end
   		
   end
	end
end
