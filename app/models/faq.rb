class Faq < ActiveRecord::Base
	has_many :faq_questions, :dependent => :destroy

	accepts_nested_attributes_for :faq_questions, allow_destroy: true
end
