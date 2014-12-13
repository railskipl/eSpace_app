class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post, presence: true
  # validates :comments, presence: true 
    # belongs_to :user

   self.per_page = 4

end
