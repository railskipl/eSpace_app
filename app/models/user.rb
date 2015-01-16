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
  has_one :bank_detail, :dependent => :destroy
  has_one :credit_card, :dependent => :destroy
  has_many :disputes, :dependent => :destroy


  delegate :stripe_recipient_token, :to => :bank_detail, :prefix => true

  def toggle_status
    self.status = !self.status?
    self.update_column(:status,self.status)
  end

  def self.get_users(q)
    where("(LOWER(name) like ? or LOWER(last_name) like ? or LOWER(email) like ?) and admin =?","%#{q}%", "%#{q}%", "%#{q}%",false).order('created_at DESC')
  end

  def self.get_disputes
    joins(:disputes).select("users.*,disputes.amount as amt,disputes.status as transaction_status").where("disputes.status != ?","refund")
  end

  def self.is_present_facebook_oauth(auth)
    config = YAML.load_file("#{Rails.root}/config/facebook.yml")

    if Rails.env.development?
      oauth = Koala::Facebook::OAuth.new(config['development']['app_id'].to_s, config['development']['secret_key'].to_s)
    else
      oauth = Koala::Facebook::OAuth.new(config['production']['app_id'].to_s, config['production']['secret_key'].to_s)
    end

      new_access_token = oauth.exchange_access_token(auth["credentials"]["token"])
      user = User.where(provider: auth.provider, uid: auth.uid).first

      @new_token = user.update_columns(oauth_token: new_access_token) rescue nil
      return user
  end

  def self.find_facebook_oauth(auth, alt_email)

    User.where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|

      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = alt_email
      user.name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_expires_at = Time.at(auth["credentials"]["expires_at"])
      user.password  = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end

  end

  def active_for_authentication?
    super && self.status # i.e. super && self.is_active
  end

  def self.admin_search
    where("admin =?",false).order('created_at DESC')
  end



  #Message count
  def check_message

    reminders =[]
    reminders = Message.select(:sender_id,:is_read).where("recipient_id = ? AND is_read =?",self.id,false)
    count = 0
    reminders.each do |r|
      unless r.is_read
        count += 1
      end
    end
    return count
  end



end
