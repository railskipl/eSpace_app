class BankDetail < ActiveRecord::Base
	
	def self.has_bank_detail(current_user)
		where('user_id = ?', current_user)
	end
end
