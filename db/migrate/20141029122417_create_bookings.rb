class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :stripe_customer_token
      t.string :stripe_charge_id
      t.float :price
      t.integer :post_id
      t.integer :user_id
      t.string :email

      t.timestamps
    end
  end
end
