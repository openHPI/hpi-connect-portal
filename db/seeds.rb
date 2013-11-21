# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

<<<<<<< HEAD
def createJobOffers
	JobOffer.delete_all
	JobOffer.create(title: "tele-Task developer", description: "The Job includes the development of new features for tele-Task", 
		chair:"Internet-Technologien und -Systeme", start_date: Date.new(2013,12,1), time_effort: 10, compensation: 11.50,
		:programming_language_ids => [6])
	JobOffer.create(title: "Touch floor", description: "The student extends the functionality of the touch floor.", 
		chair:"Human Computer Interaction", start_date: Date.new(2013,12,3), time_effort: 6, compensation: 11.50,
		:programming_language_ids => [1,2])

end

def createProgrammingLanguages
	ProgrammingLanguage.create(name: "C")
	ProgrammingLanguage.create(name: "C++")
	ProgrammingLanguage.create(name: "Java")
	ProgrammingLanguage.create(name: "Javascript")
	ProgrammingLanguage.create(name: "Python")
	ProgrammingLanguage.create(name: "Ruby")
	ProgrammingLanguage.create(name: "Smalltalk")
end


createProgrammingLanguages
createJobOffers
=======

JobOffer.create(
	:title => 'Supporting the lab operations of the chair',
	:description => 'We want you to help in implementing a new modelling tool designed for embedded systems',
	:chair => 'System Analysis and Modeling',
	:start_date => Date.new(2013, 10, 1),
	:end_date => Date.new(2014, 03, 31),
	:time_effort => 7,
	:compensation => 10,
	:programming_languages_attributes => [
											{:name => 'C'},
											{:name => 'C++'},
											{:name => 'Java'}])

languages = Language.create([{ name: 'Englisch'}, { name: 'Deutsch'}, { name: 'Spanisch'}, { name: 'Französisch'}, { name: 'Chinesisch'}])
programming_languages = ProgrammingLanguage.create([{ name: 'Ruby'}, { name: 'Java'}, { name: 'C'}, { name: 'C++'}, { name: 'Python'}, { name: 'Smalltalk'}])

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
	languages: [languages.first], 
	programming_languages: [programming_languages.first]
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
	languages: [languages.last], 
	programming_languages: [programming_languages.first]
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
	languages: [languages.first, languages.last], 
	programming_languages: [programming_languages.first, programming_languages.last]
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
	languages: languages, 
	programming_languages: programming_languages
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
	languages: languages, 
	programming_languages: programming_languages
}])
>>>>>>> origin/develop-ja
