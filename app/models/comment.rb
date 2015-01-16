class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post, presence: true
  # validates :comments, presence: true
    # belongs_to :user
  delegate :name, :to => :user, :prefix => true

end
