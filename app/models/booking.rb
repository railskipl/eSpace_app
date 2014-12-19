class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user

	scope :booking_cancelled, -> {where(is_cancel: true)}

	def self.result_area(post)
		select("area").where("post_id = ? and pickup_date >= ?", post.id, Date.today)
	end
end
