class Comment < ActiveRecord::Base
	belongs_to :post
	has_many :ratings
    # belongs_to :user


end
