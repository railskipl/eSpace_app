class Faq < ActiveRecord::Base
	has_many :faq_questions, :dependent => :destroy

	accepts_nested_attributes_for :faq_questions, allow_destroy: true

	def self.faq_search(search_condition)
	  @faqss = Faq.where('title LIKE ? ',search_condition)
      if @faqss.present?
         @faqs = @faqss
      else
        faq_question = FaqQuestion.where('question LIKE ? OR answer LIKE ?',search_condition, search_condition )
        @a = []
        faq_question.each do |fa|
          @a << fa.faq_id
        end
        @faqs = []
        @a.uniq.each do |fa|
          @faqs << Faq.find(fa)
        end
      end
      @faqs
	end
end
