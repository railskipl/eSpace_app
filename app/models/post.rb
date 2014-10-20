class Post < ActiveRecord::Base

	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
  has_many :comments
	belongs_to :user
  has_many :messages
	has_attached_file :photo, :styles => { :thumb => "100x100", :medium => "350x350" },
  
    :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/estore_management/posts/:id/:style/:basename.:extension",
                    
                    :convert_options => {
                          :thumb => "-compose Copy -gravity center -extent 100x100",
                          :medium => "-compose Copy -gravity center -extent 350x350",
                          
                      }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']




  def self.search(search, page)
 
    posts = Post.order(:id)
    posts = posts.where("area <= ?", "#{search[:area]}") if search[:area].present?
    posts = posts.where("price_sq_ft <= ?", "#{search[:price]}") if search[:price].present?
    posts = posts.where("address like ?", "%#{search[:address]}%") if search[:address].present?
    posts.page(page).per_page(10)
    
  end


  def self.search_post(search, userID)
    if search
      search[:status] = search[:status] == 'Active' ? true : false
      where(archive: false, user_id: userID, status: search[:status])
    else
      where(archive: false, user_id: userID)
    end 
  end




def average_stars
  comments.average(:stars)
end

end
