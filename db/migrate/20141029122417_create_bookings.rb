class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :stripe_customer_token
      t.float :price
      t.integer :user_id

      t.timestamps
    end
  end
end
