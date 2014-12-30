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

  def remaining_area(post)
    result = Booking.result_area(post)
    @a = []
    result.each do |ru|
       @a << ru.area.to_f
    end
    if @a.nil? || @a.blank?
      @remaining_area = post.area
    else
      @remaining_area = post.area - @a.inject{|sum, x| sum + x}
    end
  end


  def payment_status(booking)
    if current_user == booking.user
      "Payment Send"
    else
      if booking.is_confirm?
        "Payment Released"
      else
        "-"
      end
    end
  end

  def received_by_poster(booking)
    if current_user == booking.user
      if booking.is_confirm?
        booking.try(:price)
      elsif booking.is_cancel?
        booking.try(:refund_finder)
      end
    else
      booking.try(:cut_off_price)
    end
  end
end
