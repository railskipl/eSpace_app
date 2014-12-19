class AddNotificationForEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_for_email, :boolean
  end
end
