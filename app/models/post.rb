class Post < ActiveRecord::Base

	geocoded_by :address
	after_validation :geocode, :if => :address_changed?

	belongs_to :user

	has_attached_file :photo, :styles => { :thumb => "350x350>" },
  
    :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/estore_management/posts/:id/:style/:basename.:extension",
                    
                    :convert_options => {
                          :thumb => "-compose Copy -gravity center -extent 100x100",
                          :medium => "-compose Copy -gravity center -extent 350x350",
                          
                      }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']


  
end
