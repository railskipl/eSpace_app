module CancelBooking
 module ClassMethods
   def cancel_booking_deduction(days,price)
      if days >= GlobalConstants::CANCEL_DAYS
         @deducted_amount = price.to_f - (price.to_f * GlobalConstants::CANCEL_LAST_2_DAYS)
         return @deducted_amount
      elsif(days > GlobalConstants::MIN_CANCEL_DAYS && days <= GlobalConstants::CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::BEFORE_CANCEL_WITHIN_20_DAYS)
        return @deducted_amount
      elsif(days <=GlobalConstants::MIN_CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::BEFORE_CANCEL_20_DAYS)
        return @deducted_amount
      end
    end

    def cancel_booking_by_finder_less8(days,price)

      if days >= GlobalConstants::CANCEL_DAYS
         @deducted_amount = (price.to_f - GlobalConstants::ADMIN_COMISSION) * GlobalConstants::BEFORE_CANCEL_20_DAYS
         return @deducted_amount
      elsif(days > GlobalConstants::MIN_CANCEL_DAYS && days <= GlobalConstants::CANCEL_DAYS)
        @deducted_amount = (price.to_f - GlobalConstants::ADMIN_COMISSION) * GlobalConstants::BEFORE_CANCEL_WITHIN_20_DAYS_LESS8
        return @deducted_amount
      elsif(days <=GlobalConstants::MIN_CANCEL_DAYS)
        @deducted_amount = (price.to_f - GlobalConstants::ADMIN_COMISSION) * GlobalConstants::CANCEL_LAST_2_DAYS
        return @deducted_amount
      end
    end


    def send_money_to_poster(days,price)
      if days >= GlobalConstants::CANCEL_DAYS
         @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SUCCESSFUL_PAYMENT_TRANSFER)
         return @deducted_amount
      elsif(days > GlobalConstants::MIN_CANCEL_DAYS && days <= GlobalConstants::CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SEND_WITHING_20_DAYS)
        return @deducted_amount
      elsif(days <=GlobalConstants::MIN_CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SEND_LAST_2_DAYS)
        return @deducted_amount
      end
    end



    def send_money_to_admin(days,price)
      if days >= GlobalConstants::CANCEL_DAYS
         @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SUCCESSFUL_PAYMENT_TRANSFER) - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
         return @deducted_amount
      elsif(days > GlobalConstants::MIN_CANCEL_DAYS && days <= GlobalConstants::CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SUCCESSFUL_PAYMENT_TRANSFER) - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
        return @deducted_amount
      elsif(days <=GlobalConstants::MIN_CANCEL_DAYS)
        @deducted_amount = price.to_f - (price.to_f * GlobalConstants::SUCCESSFUL_PAYMENT_TRANSFER) - GlobalConstants::STRIPE_COMISSION_FOR_PAYOUT
        return @deducted_amount
      end
    end

    def days_diff(drop_off_date)
      @current_date = Date.today
      @drop_off_date = drop_off_date
      @days_diff = @drop_off_date - @current_date
      return @days_diff.round
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end

end