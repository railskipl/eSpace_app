class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.decimal    :value
      t.integer    :vote_count
      t.references :item,  polymorphic: true, index: true
      t.references :rater, polymorphic: true, index: true

      t.timestamps
    end
  end
end

