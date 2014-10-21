class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]

  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  
  has_many :authentications
  has_many :posts
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :recipient_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :ratings
  has_many :comments
  def self.json_tokens(query)
    users = where("email like ?", "%#{query}%")
    if users.empty?
    else
     users
    end
  end

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
   end
  end

  #Message count
  def check_message
    reminders =[]
    
    reminders = Message.where("recipient_id = ?",self.id)
    count = 0
    reminders.each do |r|
      unless r.is_read
        count += 1
      end
    end
    return count
  end


end
