class AddStarsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :stars, :integer,:default => 0
  end
end
