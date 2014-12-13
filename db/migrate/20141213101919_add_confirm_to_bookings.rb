class AddConfirmToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :is_confirm, :boolean, default: false
  end
end
