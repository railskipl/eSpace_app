class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.float :area
      t.float :price_sq_ft
      t.boolean :pick_up, :default => false
      t.boolean :drop_off, :default => false
      t.float :price_include_pick_up
      t.float :price_include_drop_off
      t.date :pick_up_avaibilty_start_date
      t.date :pick_up_avaibility_end_date
      t.date :drop_off_avaibility_start_date
      t.date :drop_off_avaibility_end_date
      t.boolean :status, :default => true
      t.text :additional_comments
      t.text :address
      t.float :latitude
      t.float :longitude
      t.integer :user_id

      t.timestamps
    end
  end
end
