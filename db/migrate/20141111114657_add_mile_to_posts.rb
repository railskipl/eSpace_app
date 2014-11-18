class AddMileToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :miles, :string
  end
end
