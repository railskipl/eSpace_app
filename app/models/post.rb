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
                          :thumb => "-compose Copy -gravity center -extent 91x61",
                          :medium => "-compose Copy -gravity center -extent 512x344",
                          
                      }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  def overall_rating
    comments.sum(:rating).to_f / comments.size
  end


  def self.search(search, page, userID)
    posts = Post.where("user_id != ?", "#{userID}")
    posts = posts.where("area <= ?", "#{search[:area]}") if search[:area].present?
    posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?
    posts = posts.near(search[:address], search[:miles]) if search[:address].present? && search[:miles].present?
    posts = posts.where("LOWER(address) like ?", "%#{search[:address].downcase}%") if search[:address].present? != search[:miles].present?
    posts = posts.where("drop_off = ?", "#{search[:dropoff]}") if search[:dropoff].present?
    posts = posts.where("pick_up = ?", "#{search[:pickup]}") if search[:pickup].present?

    posts.page(page).per_page(4)
  
  end

  def self.search_overview(search, userID)
    posts = Post.where("user_id != ?", "#{userID}")
    posts = posts.where("area <= ?", "#{search[:area]}") if search[:area].present?
    posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?
    posts = posts.near(search[:address], search[:miles]) if search[:address].present? && search[:miles].present?
    posts = posts.where("LOWER(address) like ?", "%#{search[:address].downcase}%") if search[:address].present? != search[:miles].present?
    posts = posts.where("drop_off = ?", "#{search[:dropoff]}") if search[:dropoff].present?
    posts = posts.where("pick_up = ?", "#{search[:pickup]}") if search[:pickup].present?
    posts
  end

  # def self.search_without_login(search, page)
  #   posts = Post.where("area <= ?", "#{search[:area]}") if search[:area].present?
  #   posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?
  #   posts = posts.where("LOWER(address) like ?", "%#{search[:address].downcase}%") if search[:address].present?
  #   posts.page(page).per_page(4)
  # end


  def self.search_post(search, userID)
    if search
      search[:status] = search[:status] == 'Active' ? true : false
      where(archive: false, user_id: userID, status: search[:status])
    else
      where(archive: false, user_id: userID)
    end 
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
