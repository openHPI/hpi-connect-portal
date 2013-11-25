# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


LanguagesStudent.delete_all
ProgrammingLanguagesStudent.delete_all

Language.delete_all
Language.create([
									{ name: 'Englisch'},
									{ name: 'Deutsch'},
									{ name: 'Spanisch'},
									{ name: 'Französisch'},
									{ name: 'Chinesisch'}
])

ProgrammingLanguage.delete_all
ProgrammingLanguage.create([
														{ name: 'Ruby'},
														{ name: 'Java'},
														{ name: 'C'},
														{ name: 'C++'},
														{ name: 'Python'},
														{ name: 'Smalltalk'}
])

JobOffer.delete_all
JobOffer.create([{
	title: "Touch floor", 
	description: 'The student extends the functionality of the touch floor.', 
	chair: 'Human Computer Interaction', 
	start_date: '2013-11-01', 
	time_effort: 6,
	compensation: 11.50,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++'])
}])

JobOffer.create([{
	title: "tele-Task developer", 
	description: 'The Job includes the development of new features for tele-Task', 
	chair: 'Internet-Technologien und -Systeme', 
	start_date: '2013-11-11', 
	time_effort: 10,
	compensation: 12.00,
	languages: Language.where(:name => ['Deutsch', 'English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java'])
}])

JobOffer.create([{
	title: "Supporting the lab operations of the chair", 
	description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
	chair: 'System Analysis and Modeling', 
	start_date: '2014-01-01', 
	time_effort: 8,
	compensation: 10.00,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk'])
}])

Student.delete_all
Student.create([{
	first_name: 'Dieter', 
	last_name: 'Nuhr', 
	semester: '1', 
	academic_program: 'Bachelor', 
	birthday: '1970-12-10', 
	education: 'Abitur', 
	additional_information: 'No', 
	homepage: 'www.dieter.de', 
	github: 'www.github.com/dieter', 
	facebook: 'www.faceboook.com/dieter', 
	xing: 'www.xing.com/dieter', 
	linkedin: 'www.linkedin.com/dieter', 
	languages: Language.where(:name => 'English'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java'])
}])

Student.create([{
	first_name: 'Jasper', 
	last_name: 'Schulze', 
	semester: '5', 
	academic_program: 'Bachelor', 
	birthday: '1970-12-10', 
	education: 'Abitur', 
	additional_information: 'No', 
	homepage: 'www.dieter.de', 
	github: 'www.github.com/dieter', 
	facebook: 'www.faceboook.com/dieter', 
	xing: 'www.xing.com/dieter', 
	linkedin: 'www.linkedin.com/dieter', 
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python'])
}])

Student.create([{
	first_name: 'Frank', 
	last_name: 'Blechschmidt', 
	semester: '5', 
	academic_program: 'Bachelor', 
	birthday: '1970-12-10', 
	education: 'Abitur', 
	additional_information: 'No', 
	homepage: 'www.dieter.de', 
	github: 'www.github.com/dieter', 
	facebook: 'www.faceboook.com/dieter', 
	xing: 'www.xing.com/dieter', 
	linkedin: 'www.linkedin.com/dieter', 
	languages: Language.where(:name => ['Deutsch', 'English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++'])
}])

Student.create([{
	first_name: 'Malte', 
	last_name: 'Mues', 
	semester: '5', 
	academic_program: 'Bachelor', 
	birthday: '1970-12-10', 
	education: 'Abitur', 
	additional_information: 'No', 
	homepage: 'www.dieter.de', 
	github: 'www.github.com/dieter', 
	facebook: 'www.faceboook.com/dieter', 
	xing: 'www.xing.com/dieter', 
	linkedin: 'www.linkedin.com/dieter', 
	languages: Language.all, 
	programming_languages: ProgrammingLanguage.all
}])

Student.create([{
	first_name: 'Julia', 
	last_name: 'Steier', 
	semester: '5', 
	academic_program: 'Bachelor', 
	birthday: '1969-12-04', 
	education: 'Abitur', 
	additional_information: 'No', 
	homepage: 'www.Günther.de', 
	github: 'www.github.com/dieter', 
	facebook: 'www.faceboook.com/dieter', 
	xing: 'www.xing.com/dieter', 
	linkedin: 'www.linkedin.com/dieter', 
	languages: Language.all, 
	programming_languages: ProgrammingLanguage.all
}])