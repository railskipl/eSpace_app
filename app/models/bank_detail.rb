class BankDetail < ActiveRecord::Base

	belongs_to :user
	
	# def self.has_bank_detail(current_user)
	# 	where('user_id = ?', current_user)
	# end
end
