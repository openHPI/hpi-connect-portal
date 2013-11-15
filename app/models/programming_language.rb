class ProgrammingLanguage < ActiveRecord::Base
	belongs_to :job_offer
	validates_uniqueness_of :name
end
