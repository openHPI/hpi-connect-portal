class ProgrammingLanguage < ActiveRecord::Base
	has_and_belongs_to_many :job_offer
	has_and_belongs_to_many :students
	validates_uniqueness_of :name

end
