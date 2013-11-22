class Student < ActiveRecord::Base
	has_and_belongs_to_many :languages
	has_and_belongs_to_many :programming_languages

	has_attached_file 	:photo,
						:url  => "/assets/students/:id/:style/:basename.:extension",
    					:path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
    has_attached_file 	:cv,
						:url  => "/assets/students/:id/:style/:basename.:extension",
    					:path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"

    def self.search_student(string)
    	string = string.downcase
        tmp_student = Student.where("
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
    	tmp_student_programming = search_students_by_programming_language(string)
        tmp_student_language = search_students_by_language(string)
    	tmp_concate = tmp_student + tmp_student_programming + tmp_student_language
    	tmp_concate.uniq.sort_by{|x| [x.last_name, x.first_name]}
    end

    def self.search_students_by_programming_language(string)
    	Student.joins(:programming_languages).where('lower(programming_languages.name) LIKE ?',string.downcase).
        sort_by{|x| [x.last_name, x.first_name]}
    end

     def self.search_students_by_language(string)
        Student.joins(:languages).where('lower(languages.name) LIKE ?',string.downcase).
        sort_by{|x| [x.last_name, x.first_name]}
    end      
end
