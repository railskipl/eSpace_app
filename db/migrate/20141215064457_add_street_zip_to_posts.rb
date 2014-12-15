class AddStreetZipToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :street_add, :text
    add_column :posts, :apt, :string
    add_column :posts, :city, :string
    add_column :posts, :state, :string
    add_column :posts, :zip_code, :string
  end
end
