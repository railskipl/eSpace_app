class Message < ActiveRecord::Base

  attr_accessor :user_ids
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :message
  belongs_to :post
  has_many :users

  delegate :name,:email, :to => :sender, :prefix => true
  delegate :name,:email, :to => :recipient, :prefix => true

  attr_reader :user_tokens

    def user_tokens=(ids)
        self.user_ids = ids.split(",")
    end

    def msg(id)
      message_id = id
    end

end
