class FaqQuestion < ActiveRecord::Base
	belongs_to :faq
	validates_presence_of :question
end
