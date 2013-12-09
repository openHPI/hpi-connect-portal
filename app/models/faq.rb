class Faq < ActiveRecord::Base
	validates :question, :answer, presence: true
end
