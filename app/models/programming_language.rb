class ProgrammingLanguage < ActiveRecord::Base
    #equal to has_and_belongs_to_many :students
    has_many :programming_languages_students
    has_many :students, :through => :programming_languages_students

	has_and_belongs_to_many :job_offer
	validates_uniqueness_of :name

end
