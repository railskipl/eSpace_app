class AboutU < ActiveRecord::Base
	has_attached_file :photo, :styles => { :thumb => "91x61", :medium => "512x344" }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

end
