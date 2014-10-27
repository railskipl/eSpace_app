class Comment < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

  validates :rating,
             presence: true, 
             numericality: { only_integer: true,
                             less_than_or_equal_to: 5,
                             greater_than_or_equal_to: 1 }

  

  validates :post, presence: true
    # belongs_to :user

end
