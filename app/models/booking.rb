class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user

	scope :booking_cancelled, -> {where(is_cancel: true)}

	delegate :name, :last_name ,:to => :user, :prefix => true
	delegate :name, :last_name ,:to => :poster, :prefix => true

	def self.result_area(post)
		select("area").where("post_id = ? and pickup_date >= ? and is_cancel != ?", post.id, Date.today, true)
	end
end
