class AddIndexToFaqQuestions < ActiveRecord::Migration
  def change
    add_index :faq_questions, :faq_id
  end
end
