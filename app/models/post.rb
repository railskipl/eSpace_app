class Post < ActiveRecord::Base

	geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_validation :lat_changed?

  has_many :comments
	belongs_to :user
  has_many :messages
  has_many :ratings
  has_many :bookings

	has_attached_file :photo, :styles => { :thumb => "91x61", :medium => "512x344" },
  
    :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/estore_management/posts/:id/:style/:basename.:extension",
                    
                    :convert_options => {
                          :thumb => "-background '#999' -compose Copy -gravity center -extent 91x61",
                          :medium => "-background '#999' -compose Copy -gravity center -extent 512x344",
                          
                      }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']


  # Check overall ratings an reviews
  def overall_rating
    if comments.size != 0
      comments.sum(:rating).to_f / comments.size
    else
      comments.sum(:rating)
    end
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

    posts.page(page).per_page(4)
    
  end

  # Result show on map
  def self.search_overview(search, page, sort)

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



  private

    def lat_changed?
      if (self.address_changed?)
          if !(self.latitude_changed?)
              self.errors.add(:address, "is not valid")
              return false
          end
      end
      return true
    end




end
