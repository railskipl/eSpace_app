class AddTitleToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :title, :string
  end
end
