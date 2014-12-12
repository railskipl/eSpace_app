class AddDetailsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :area, :string
  end
end
