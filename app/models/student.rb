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
    	string = string.downcase
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
                ", string, string, string, string, string, string, string, string, string).to_a
    	tmpStudentProgramming = searchStudentsByProgrammingLanguage(string)
        tmpStudentLanguage = searchStudentsByLanguage(string)
    	tmpConcate = tmpStudent + tmpStudentProgramming + tmpStudentLanguage
    	tmpConcate.uniq.sort{|a,b| self.sortDecision(a,b)}
    end
    def self.searchStudentsByProgrammingLanguage(string)
    	tmpStudentIDs = []
    	ProgrammingLanguage.where("lower(name) LIKE ?", string.downcase).each {
    		|each| 
    		tmp = ProgrammingLanguagesStudent.where(programming_language_id: each.id).to_a
             tmp.each{
    			|x| 
    			tmpStudentIDs << Student.find(x.student_id)
    		}
    	}
    	return tmpStudentIDs.sort{|a,b| self.sortDecision(a,b)}
    end

     def self.searchStudentsByLanguage(string)
        tmpStudentIDs = []
        Language.where("lower(name) LIKE ?", string.downcase).each {
            |each| 
            tmp = LanguagesStudent.where(language_id: each.id).to_a
            tmp.each{
                |x| 
                tmpStudentIDs << Student.find(x.student_id)
            }
        }
        return tmpStudentIDs.sort{|a,b| self.sortDecision(a,b)}
    end

    def self.sortDecision(a,b)
        if a.last_name < b.last_name
            return -1
        elsif a.last_name > b.last_name
            return 1
        else
            if a.first_name <b.first_name
                return -1
            elsif b.first_name > a.first_name
                return 1
            else
                return 0
            end
        end
    end         
end
