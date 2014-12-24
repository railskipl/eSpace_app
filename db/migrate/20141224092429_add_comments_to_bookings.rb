class AddCommentsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :comment, :text
  end
end
