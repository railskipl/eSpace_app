module BookingsHelper

  def payment_status(booking)
    if current_user == booking.user
       if booking.name == "cancel"
         "Cancel"
       else
         "Send"
       end
    else
      if booking.name == "created"
        "Waiting for confirmation"
      elsif booking.name == "cancel"
        "Cancel"
      else
        "Received"
      end
    end
  end

  def post_link(booking)
    text = current_user == booking.user ? "View booking made by me" : "View order received"
    link_to text, booking_path(booking.id)
  end

  def send_by_user(booking)
    if booking.name == "cancel"
      booking.refund_finder
    else
      booking.price
    end
  end

  def received_by_poster(booking)
     if booking.name == "cancel" || booking.name == "transfered"
      booking.cut_off_price
    else
      '-'
    end
  end
end
