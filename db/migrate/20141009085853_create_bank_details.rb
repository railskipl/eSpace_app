class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.string :full_name
      t.string :stripe_card_id_token
      t.string :stripe_recipient_token
      t.string :card_number
      t.timestamps
    end
  end
end
