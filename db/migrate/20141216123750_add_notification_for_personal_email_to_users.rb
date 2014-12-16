class AddNotificationForPersonalEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_for_personal_email, :boolean
  end
end
