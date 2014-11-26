class CreateAccessIds < ActiveRecord::Migration
  def change
    create_table :access_ids do |t|
      t.string :email

      t.timestamps
    end
  end
end
