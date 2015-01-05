class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.float :amount
      t.string :status
      t.integer :booking_id
      t.integer :user_id

      t.timestamps
    end
  end
end
