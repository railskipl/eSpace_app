class AddIndexToMessages < ActiveRecord::Migration
  def change
  	add_index :messages, :sender_id
    add_index :messages, :recipient_id
    add_index :messages, :message_id
    add_index :messages, :post_id
  end
end
