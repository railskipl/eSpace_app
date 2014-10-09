class CreateContactus < ActiveRecord::Migration
  def change
    create_table :contactus do |t|
      t.string :email
      t.string :subject
      t.text :message
      t.string :name

      t.timestamps
    end
  end
end
