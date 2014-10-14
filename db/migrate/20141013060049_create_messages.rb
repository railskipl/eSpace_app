class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.boolean :is_read,:default => false
      t.boolean :is_deleted_by_sender,:default => false
      t.boolean :is_deleted_by_recipient,:default => false
      t.boolean :is_trashed_by_recipient,:default => false
      t.references :sender
      t.references :recipient
      t.timestamps
    end
  end
end
