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
    	tmpConcate.uniq.sort_by{|x| [x.last_name, x.first_name]}
    end

    def self.searchStudentsByProgrammingLanguage(string)
    	Student.joins(:programming_languages).where('lower(programming_languages.name) LIKE ?',string.downcase).
        sort_by{|x| [x.last_name, x.first_name]}
    end

     def self.searchStudentsByLanguage(string)
        Student.joins(:languages).where('lower(languages.name) LIKE ?',string.downcase).
        sort_by{|x| [x.last_name, x.first_name]}
    end      
end
