class CreateFaqQuestions < ActiveRecord::Migration
  def change
    create_table :faq_questions do |t|
      t.integer :faq_id
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
