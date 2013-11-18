class Student < ActiveRecord::Base
	has_and_belongs_to_many :languages
	has_and_belongs_to_many :programming_languages

	has_attached_file 	:photo,
						:url  => "/assets/students/:id/:style/:basename.:extension",
    					:path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
    has_attached_file 	:cv,
						:url  => "/assets/students/:id/:style/:basename.:extension",
    					:path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"

    def self.searchStudent(string)
    	tmpStudent = Student.where("
                lower(first_name) LIKE ?
                OR lower(last_name) LIKE ?
                OR lower(academic_program) LIKE ?
                OR lower(education) LIKE ?
                OR lower(homepage) LIKE ?
                OR lower(github) LIKE ?
                OR lower(facebook) LIKE ?
                OR lower(xing) LIKE ?
                OR lower(linkedin) LIKE ?
                ", string, string, string, string, string, string, string, string, string).order("last_name, first_name")
    	tmpStudentProgramming = searchStudentsByProgrammingLanguage(string)
    	tmpStudentLanguage = searchStudentsByLanguage(string)
    	tmpConcate = tmpStudent + tmpStudentProgramming + tmpStudentLanguage
    	tmpConcate.uniq
    end
    def self.searchStudentsByProgrammingLanguage(string)
    	tmpStudentIDs = []
    	logger.debug("Test: #{ProgrammingLanguage.where("lower(name) LIKE ?", string).all}")
    	ProgrammingLanguage.where("lower(name) LIKE ?", string).each {
    		|each| 
    		tmp = ProgrammingLanguagesStudent.where(programming_language_id: each.id).all
    		tmp.each{
    			|x| 
    			tmpStudentIDs << Student.find(x.student_id)
    		}
    	}
    	return tmpStudentIDs
    end

     def self.searchStudentsByLanguage(string)
        tmpStudentIDs = []
        Language.where("lower(name) LIKE ?", string).each {
            |each| 
            tmp = LanguagesStudent.where(language_id: each.id).all
            tmp.each{
                |x| 
                tmpStudentIDs << Student.find(x.student_id)
            }
        }
        return tmpStudentIDs
    end
end
