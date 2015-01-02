class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.string :name
      t.integer :booking_id

      t.timestamps
    end
    add_index :payment_histories, :booking_id
  end
end
