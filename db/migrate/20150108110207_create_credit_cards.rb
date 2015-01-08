class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :email
      t.string :stripe_customer_id
      t.integer :user_id
      t.string :last_digit

      t.timestamps
    end
  end
end
