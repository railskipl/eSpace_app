module DisputesHelper

	def check_disputes(booking_id, user_id) 


		dispute = Dispute.select("status").find_by_booking_id_and_user_id(booking_id, user_id)

	    if dispute.present?
			if dispute.status = "refund" && dispute.status = "charge"
				"Already refunds | Already charged".html_safe
			elsif dispute.status = "refund"
				"Already refunds | #{link_to "Charge extra money", charge_to_finder_dispute_path(booking_id)}".html_safe
			elsif dispute.status = "charge"
				"#{link_to "Sending money", send_money_to_finder_dispute_path(booking_id)}  | Already Charged".html_safe 
			end	
		else
				"#{link_to "Sending money", send_money_to_finder_dispute_path(booking_id)} |  #{link_to "Charge extra money", charge_to_finder_dispute_path(booking_id)}".html_safe
			
		end
	end
end
