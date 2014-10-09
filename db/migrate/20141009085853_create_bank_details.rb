class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.string :full_name
      t.integer :card_number

      t.timestamps
    end
  end
end
