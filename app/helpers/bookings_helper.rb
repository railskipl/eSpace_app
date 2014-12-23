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
       @deducted_amount = price.to_f - (price.to_f * 0.9) + 0.25
       return @deducted_amount
    elsif(days > 2 && days <= 20)  
      @deducted_amount = price.to_f - (price.to_f * 0.5) + 0.25
      return @deducted_amount
    elsif(days <=2)  
      @deducted_amount = price.to_f - (price.to_f * 0.3) + 0.25
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

end
