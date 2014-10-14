class Message < ActiveRecord::Base
  
  attr_accessor :user_ids
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :message
  belongs_to :post
  has_many :users
  attr_reader :user_tokens

    def user_tokens=(ids)
        self.user_ids = ids.split(",")

    end

      def subject_name(sub)
      if sub["Re"]
      	return sub
      else
      	return "Re:" + sub
      end
    end

    def msg(id)
      message_id = id
    end

end
