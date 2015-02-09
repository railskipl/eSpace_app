class RemoveIsConfirmFromBookings < ActiveRecord::Migration
  def change
    remove_column :bookings, :is_confirm, :boolean
  end
end
