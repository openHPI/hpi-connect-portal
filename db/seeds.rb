# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
languages = Language.create([{ name: 'Englisch'}, { name: 'Deutsch'}, { name: 'Spanisch'}, { name: 'Französisch'}, { name: 'Chinesisch'}])
programming_languages = ProgrammingLanguage.create([{ name: 'Ruby'}, { name: 'Java'}, { name: 'C'}, { name: 'C++'}, { name: 'Python'}])
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