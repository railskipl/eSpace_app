class AddIndexToBankDetails < ActiveRecord::Migration
  def change
  	add_index :bank_details, :user_id
  end
end
