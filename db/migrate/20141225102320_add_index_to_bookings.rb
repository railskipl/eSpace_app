class AddIndexToBookings < ActiveRecord::Migration
  def change
  	add_index :bookings, :user_id
    add_index :bookings, :post_id
    add_index :bookings, :poster_id
  end
end
