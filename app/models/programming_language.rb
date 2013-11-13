class ProgrammingLanguage < ActiveRecord::Base
	has_and_belongs_to_many :job_offers
	validates_uniqueness_of :name
end
