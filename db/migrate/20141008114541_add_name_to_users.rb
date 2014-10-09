class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :personal_email, :string
    add_column :users, :mobile_no, :integer
  end
end
