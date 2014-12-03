class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :stripe_customer_token
      t.string :stripe_charge_id
      t.string :stripe_transfer_id
      t.string :status
      t.float :price
      t.integer :post_id
      t.integer :user_id
      t.integer :poster_id
      t.string :email
      t.string :email
      t.date :dropoff_date
      t.float :dropoff_price
      t.date :pickup_date
      t.float :pickup_price
      t.float :cut_off_price
      t.boolean :is_cancel, :default => false
      t.string :random_code
      t.boolean :is_transfer,:default => false
      t.boolean :is_confirm, :default => false
      t.boolean :is_complaint,:default => false
      t.timestamps
    end
  end
end
