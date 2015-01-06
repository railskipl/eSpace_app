class AddIndexToDisputes < ActiveRecord::Migration
  def change
    add_index :disputes, :booking_id
    add_index :disputes, :user_id
  end
end
