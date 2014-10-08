class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.float :store_area
      t.text :store_details
      t.float :price_sq_ft
      t.float :total_store_space_price
      t.float :price_include_pick_up
      t.float :price_include_drop_off
      t.boolean :pick_up, :default => false
      t.boolean :drop_off, :default => false
      t.date :store_available_start_date
      t.date :store_available_end_date
      t.date :pick_up_avaibilty_start_date
      t.date :pick_up_avaibility_end_date
      t.date :drop_off_avaibility_start_date
      t.date :drop_off_avaibility_end_date
      t.integer :transportation_range
      t.boolean :status, :default => true

      t.timestamps
    end
  end
end
