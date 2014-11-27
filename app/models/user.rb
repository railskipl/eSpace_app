class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook]

  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  
  has_many :authentications, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :recipient_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :dependent => :destroy
 
  has_many :comments, :dependent => :destroy
  has_many :bookings, :dependent => :destroy

  
  def self.json_tokens(query)
    users = where("email like ?", "%#{query}%")
    if users.empty?
    else
     users
    end
  end

  def self.find_for_facebook_oauth(auth, alt_email)

    User.where(auth.slice("provider", "uid")).first_or_create do |user|
    
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_expires_at = Time.at(auth["credentials"]["expires_at"])
      user.personal_email = alt_email
      user.password  = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
    
  end

  def self.is_present_facebook_oauth(auth)
    if Rails.env.development?
      oauth = Koala::Facebook::OAuth.new("382895341863463", "70e00b19e5cf11f56990e9402da7e8f5")
      
    else  
      oauth = Koala::Facebook::OAuth.new("463439180461791", "da2a8a7e85b8c3eda15f129204dd9d23")
    end  
      new_access_token = oauth.exchange_access_token(auth["credentials"]["token"])
      user = User.where(auth.slice(:provider, :uid)).first
      @new_token = user.update_columns(oauth_token: new_access_token) rescue nil
      User.where(auth.slice(:provider, :uid)).first
  end

  def active_for_authentication?
    super && self.status # i.e. super && self.is_active
  end

  

  #Message count
  def check_message
    reminders =[]
    reminders = Message.select(:sender_id,:is_read).where("recipient_id = ? AND is_read =?",self.id,false).uniq!
    count = 0
    reminders.each do |r|
      unless r.is_read
        count += 1
      end
    end
    return count
  end



end
