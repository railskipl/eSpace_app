class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user
end
