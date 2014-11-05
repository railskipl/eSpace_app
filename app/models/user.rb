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
      user.personal_email = alt_email
      user.password  = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
    
  end

  def self.is_present_facebook_oauth(auth)
      where(auth.slice(:provider, :uid)).first 
  end

  #  def search(search)
  # users = User.order(:name)
  # users = users.where("name like ?", "%#{search}%") if name.present?
  # # users = users.where(created_at: created_at) if created_at.present?
  # users
  # end


def self.search(query)
  date = Date.today.beginning_of_week
  daily =(Date.today).to_s
  weekly =(Date.today.beginning_of_week..(date + 6.days))
  monthly= (Date.today.beginning_of_month..Date.today.end_of_month)
  where("name like ? AND created_at like ? ","%#{query}%","%#{daily}%") || where("name like ? AND created_at like ? ","%#{query}%","%#{weekly}%") || where("name like ? AND created_at like ? ","%#{query}%","%#{monthly}%")
end

# def self.search(search)
#   users = User.order(:id)
#   date = Date.today.beginning_of_week
#   daily =Date.today
#   weekly =Date.today.beginning_of_week..(date + 6.days)
#   monthly= Date.today.beginning_of_month..Date.today.end_of_month
#   users = users.where("name = ?", "#{search[:name]}") if search[:name].present?
#   users = users.where("daily = ?", "#{search[:daily]}") if search[:daily].present?
#   users = users.where("weekly = ?", "#{search[:weekly]}") if search[:weekly].present?
#   users.page(page).per_page(10)
   
# end
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
