class AddFinderRefundToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :refund_finder, :float
  end
end
