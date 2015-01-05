class Dispute < ActiveRecord::Base

	belongs_to :booking
	belongs_to :post
	
end
