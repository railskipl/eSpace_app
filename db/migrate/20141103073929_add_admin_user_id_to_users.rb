class AddAdminUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_user_id, :integer
  end
end
