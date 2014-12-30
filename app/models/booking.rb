class Booking < ActiveRecord::Base
	belongs_to :post
	belongs_to :poster,:class_name => 'User'
	belongs_to :user

	scope :booking_cancelled, -> {where(is_cancel: true)}

	delegate :name, :last_name ,:to => :user, :prefix => true
	delegate :name, :last_name, :provider,:user_id ,:to => :poster, :prefix => true
	delegate :address, :street_add, :apt, :city, :state, :zip_code, :area,:additional_comments, 
			 :drop_off_avaibility_end_date, :pick_up, :drop_off, :drop_off_avaibility_start_date,
			 :pick_up_avaibilty_start_date, :price_sq_ft, :pick_up_avaibility_end_date, :to => :post, :prefix => true

	def self.result_area(post)
		select("area").where("post_id = ? and pickup_date >= ? and is_cancel != ?", post.id, Date.today, true)
	end
end
