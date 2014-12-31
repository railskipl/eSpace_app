class AddAreaAvailableToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :area_available, :float, :default => 0
  end
end
