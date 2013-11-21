class ProgrammingLanguage < ActiveRecord::Base
	has_and_belongs_to_many :job_offer
	validates_uniqueness_of :name
	has_and_belongs_to_many :students
end
