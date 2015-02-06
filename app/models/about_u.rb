class AboutU < ActiveRecord::Base

  has_attached_file :photo, :styles => { :thumb => "61x61" },
    :path => "estore_management/about_us/:id/:style/:basename.:extension",
    :convert_options => {
      :thumb => "-compose Copy -gravity center -extent 61x61"
    }

    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

end
