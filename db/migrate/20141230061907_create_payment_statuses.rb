class CreatePaymentStatuses < ActiveRecord::Migration
  def change
    create_table :payment_statuses do |t|
      t.string :name
      t.integer :booking_id

      t.timestamps
    end
    add_index :payment_statuses, :booking_id
  end
end
