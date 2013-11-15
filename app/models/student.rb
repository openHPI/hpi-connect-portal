class Student < ActiveRecord::Base
	has_and_belongs_to_many :languages
	has_and_belongs_to_many :programming_languages

	has_attached_file 	:photo,
						:url  => "/assets/students/:id/:style/:basename.:extension",
    					:path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
end
