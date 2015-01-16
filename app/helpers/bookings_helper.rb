module BookingsHelper

  def cancel_booking_deduction(days,price)

  	if days >= 20
       @deducted_amount = price.to_f - (price.to_f * 0.2)
       return @deducted_amount
    elsif(days > 2 && days <= 20)
      @deducted_amount = price.to_f - (price.to_f * 0.6)
      return @deducted_amount
    elsif(days <=2)
      @deducted_amount = price.to_f - (price.to_f * 0.8)
      return @deducted_amount
    end
  end

  def cancel_booking_by_finder_less8(days,price)

    if days >= 20
       @deducted_amount = (price.to_f - 0.80) * 0.8
       return @deducted_amount
    elsif(days > 2 && days <= 20)
      @deducted_amount = (price.to_f - 0.80) * 0.4
      return @deducted_amount
    elsif(days <=2)
      @deducted_amount = (price.to_f - 0.80) * 0.2
      return @deducted_amount
    end
  end


  def send_money_to_poster(days,price)
    if days >= 20
       @deducted_amount = price.to_f - (price.to_f * 0.9)
       return @deducted_amount
    elsif(days > 2 && days <= 20)
      @deducted_amount = price.to_f - (price.to_f * 0.5)
      return @deducted_amount
    elsif(days <=2)
      @deducted_amount = price.to_f - (price.to_f * 0.3)
      return @deducted_amount
    end
  end



  def send_money_to_admin(days,price)
    if days >= 20
       @deducted_amount = price.to_f - (price.to_f * 0.9) - 0.25
       return @deducted_amount
    elsif(days > 2 && days <= 20)
      @deducted_amount = price.to_f - (price.to_f * 0.9) - 0.25
      return @deducted_amount
    elsif(days <=2)
      @deducted_amount = price.to_f - (price.to_f * 0.9) - 0.25
      return @deducted_amount
    end
  end


  def days_diff(drop_off_date)
    @current_date = Date.today
    @drop_off_date = drop_off_date
    @days_diff = @drop_off_date - @current_date
    return @days_diff.round
  end

  # def remaining_area(post)
  #   result = Booking.result_area(post)
  #   @a = []
  #   result.each do |ru|
  #      @a << ru.area.to_f
  #   end
  #   if @a.nil? || @a.blank?
  #     @remaining_area = post.area
  #   else
  #     @remaining_area = post.area - @a.inject{|sum, x| sum + x}
  #   end
  # end


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
    if current_user == booking.user
      link_to "View booking made by me", booking_path(booking.id)
    else
      if booking.is_confirm?
        link_to "View order received", booking_path(booking.id)
      else
        link_to "View order received", booking_path(booking.id)
      end
    end
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
