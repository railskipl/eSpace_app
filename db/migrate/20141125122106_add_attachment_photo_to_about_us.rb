class AddAttachmentPhotoToAboutUs < ActiveRecord::Migration
  def self.up
    change_table :about_us do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :about_us, :photo
  end
end
