class AddCustomerIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :stripe_customer_id, :string
    add_column :bookings, :on_hold, :boolean, :default=> false
  end
end
