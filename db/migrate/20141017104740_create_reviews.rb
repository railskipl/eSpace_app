class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :name
      t.integer :stars
      t.string :comments
      t.references :post, index: true
      t.timestamps
    end
  end
end
