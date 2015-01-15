class Post < ActiveRecord::Base

	geocoded_by :poster_address
  after_validation :geocode
  after_validation :lat_changed?

  has_many :comments
	belongs_to :user
  has_many :messages
  has_many :ratings
  has_many :bookings
  has_many :disputes

	has_attached_file :photo, :styles => { :thumb => "91x61", :medium => "512x344" },
  
    :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/estore_management/posts/:id/:style/:basename.:extension",
                    
                    :convert_options => {
                          :thumb => "-background '#fff' -compose Copy -gravity center -extent 91x61",
                          :medium => "-background '#fff' -compose Copy -gravity center -extent 512x344",
                          
                      }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  delegate :id, :name, :email,:last_name,:provider ,:to => :user, :prefix => true

  before_create :set_area_available
  
  # Check overall ratings an reviews
  def overall_rating
    if comments.size != 0
      comments.sum(:rating).to_f / comments.size
    else
      comments.sum(:rating)
    end
  end

  def set_area_available
    self.area_available = self.area
  end

  def poster_address
    [city, state, zip_code].compact.join(', ')
  end

  def self.get_status(q)
    where("LOWER(status) like ?", "%#{q}%")
  end

  def self.result(start_date,end_date)
    where("date(created_at) >= ? and date(created_at) <= ? ",start_date, end_date)
  end

  def self.get_archive(user)
    where(archive: true, user_id: user)
  end


  # Search result on browser page
  def self.search(search, page, sort)
    posts = Post
    posts = posts.where("area <= ?", "#{search[:area]}") if search[:area].present?
    posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?

    if sort.present?
      posts = posts.near(search[:address], search[:miles], :order => "#{sort} asc") if search[:address].present? && search[:miles].present?
    else
      posts = posts.near(search[:address], search[:miles]) if search[:address].present? && search[:miles].present?
    end
    
    posts = posts.where("LOWER(address) like ?", "%#{search[:address].downcase}%") if search[:address].present? != search[:miles].present?
    posts = posts.where("drop_off = ?", "#{search[:dropoff]}") if search[:dropoff] == '1'
    posts = posts.where("pick_up = ?", "#{search[:pickup]}") if search[:pickup] == '1'

    posts = posts.where(" drop_off_avaibility_end_date >= ? and status = ? and archive = ? and area_available >= ?",Date.today, true,false,4)

    posts.page(page).per_page(4)
    
  end

  # Result show on map
  def self.search_overview(search, page, sort)

    posts = Post
    posts = posts.where("area <= ? ", "#{search[:area]}") if search[:area].present?
    posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?

    if sort.present?
      posts = posts.near(search[:address], search[:miles], :order => "#{sort} asc") if search[:address].present? && search[:miles].present?
    else
      posts = posts.near(search[:address], search[:miles]) if search[:address].present? && search[:miles].present?
    end
    
    posts = posts.where("LOWER(address) like ?", "%#{search[:address].downcase}%") if search[:address].present? != search[:miles].present?
    posts = posts.where("drop_off = ?", "#{search[:dropoff]}") if search[:dropoff] == '1'
    posts = posts.where("pick_up = ?", "#{search[:pickup]}") if search[:pickup] == '1'
    posts = posts.where("drop_off_avaibility_end_date >= ? and status = ? and archive = ?",Date.today, true,false)
    posts = posts.where("area_available >= ?",4)
    posts.page(page)
    
  end


  def self.search_post(search, userID)
    if search
      search[:status] = search[:status] == 'Active' ? true : false
      where(archive: false, user_id: userID, status: search[:status])
    else
      where(archive: false, user_id: userID)
    end 
  end

  #Calculate remaining area
  def self.remaining_area(total_area)
    total_area - 4
    
  end


  def self.post_search(current_user)
    where("user_id != ?",current_user.id).order("id desc")
  end
  
  def self.substract_area(booking)
     p = self.find(booking["post_id"].to_i)
     p.area_available = p.area_available - booking.area.to_f
     p.save
  end

  def self.add_area(booking)
    p = self.find(booking["post_id"].to_i)
    p.area_available = p.area_available + booking.area.to_f
    p.save
  end

  private

    def lat_changed?
      if (self.address.present?)
          if !(self.latitude.present?)
              self.errors.add(:address, "is not valid")
              return false
          end
      end
      return true
    end


end
