class ProgrammingLanguagesStudent < ActiveRecord::Base
	belongs_to :student
  	belongs_to :programming_language
end
