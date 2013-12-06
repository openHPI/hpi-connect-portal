# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Standard Roles
Role.create(name: 'Student', level: 1)
Role.create(name: 'Research Assistant', level: 2)
Role.create(name: 'Admin', level: 3)

#Create User as an example deputy for all chairs
User.delete_all
User.create([
	{ firstname: "Chief",
	lastname: "Smith",
	email: "chief@smith.de",
	role: Role.where(:name => 'Student').first }
	])
User.create([
	{ firstname: "Sophie",
	lastname: "Heuser",
	email: "sophie_heuser@student.hpi.uni-potsdam.de",
	role: Role.where(:name => 'Research Assistant').first }
	])

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

StudentStatus.delete_all
StudentStatus.create([
	{ name: 'job-seeking'},
	{ name: 'employed'},
	{ name: 'employed (ext)'},
	{ name: 'no interest'},
	{ name: 'alumni'}
])

JobOffer.delete_all
JobOffer.create([{
	title: "Touch floor", 
	description: 'The student extends the functionality of the touch floor.', 
	chair: 'Human Computer Interaction', 
	status: 'completed',
	start_date: '2013-11-01', 
	time_effort: 6,
	compensation: 11.50,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
}])

JobOffer.create([{
	title: "Website Developer", 
	description: 'The student develops a wonderful website.', 
	chair: 'Epic', 
	status: 'completed',
	start_date: '2013-10-01', 
	time_effort: 9,
	compensation: 13.50,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Ruby'])
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
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	student_status: StudentStatus.where(:name => 'employed (ext)').first
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
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python']),
	student_status: StudentStatus.where(:name => 'job-seeking').first
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
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
	student_status: StudentStatus.where(:name => 'employed').first
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
	programming_languages: ProgrammingLanguage.all,
	student_status: StudentStatus.where(:name => 'employed').first
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
	programming_languages: ProgrammingLanguage.all,
	student_status: StudentStatus.where(:name => 'no interest').first
}])

Faq.delete_all
Faq.create([{
	question: "How do I make edits to my profile?", 
	answer: 'Log in to your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button.'
}])
Faq.create([{
	question: "How do I log off of HPI-HiWi-Portal?", 
	answer: 'To logout of your Monster account hover over the Sign Out option in the upper right hand corner of the page.'
}])
Faq.create([{
	question: "How can I add a profile photo?", 
	answer: 'Log into your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button. Search for Foto. Click Browse and select the photo you would like to use for your profile. Click Update Student.'
}])
Faq.create([{
	question: "Does HPI-HiWi-Portal have an Android app?", 
	answer: 'Yes, the HPI-HiWi-Portal Android app allows you to stay connected to the premier job search website to discover the latest jobs that meet your needs.'
}])
