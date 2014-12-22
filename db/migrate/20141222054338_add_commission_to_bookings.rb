class AddCommissionToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :commission, :float
  end
end
