class Dispute < ActiveRecord::Base

	belongs_to :user
	belongs_to :poster,:class_name => 'User'
	belongs_to :booking
	belongs_to :post

	delegate :id, :post_id, :area, :price, :to => :booking, :prefix => true
	delegate :name, :last_name, :to => :user, :prefix => true
	delegate :name, :last_name, :to => :poster, :prefix => true

	
end
