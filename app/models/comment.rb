class Comment < ActiveRecord::Base
	belongs_to :post
	ajaxful_rateable :stars => 5, :dimensions => [:post],:allow_update => true
end
