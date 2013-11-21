class ProgrammingLanguage < ActiveRecord::Base
	belongs_to :job_offer
	has_and_belongs_to_many :students
	validates_uniqueness_of :name

end
