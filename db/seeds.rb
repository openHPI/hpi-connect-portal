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

UserStatus.delete_all
UserStatus.create([
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

User.delete_all
User.create([{
identity_url: 'openid',
email: 'dieter.nuhr@student.hpi.uni-potsdam.de', 
firstname: 'Dieter', 
lastname: 'Nuhr',
semester: 1,
academic_program: 'Bachelor',
birthday: '1970-12-10',
education:'Abitur',
additional_information: 'No',
homepage: 'www.dieter.de',
github: 'www.github.com/dieter',
facebook: 'www.faceboook.com/dieter',
xing: 'www.xing.com/dieter',
linkedin:'www.linkedin.com/dieter',
languages: Language.where(:name => 'English'),
programming_languages: ProgrammingLanguage.where(:name => ['Java']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
is_student: true}])

User.create({
identity_url: 'stress?',
email: 'bachelor@example.com', 
firstname: 'Dunkeler', 
lastname: 'Himmel',
semester: 6,
academic_program: 'Bachelor',
birthday: '1970-12-10',
education:'Abitur',
additional_information: 'No',
homepage: 'www.dieter.de',
github: 'www.github.com/dieter',
facebook: 'www.faceboook.com/dieter',
xing: 'www.xing.com/dieter',
linkedin:'www.linkedin.com/dieter',
languages: Language.where(:name => 'Deutsch'),
programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python']),
user_status: UserStatus.where(:name => 'job-seeking').first,
is_student: true})

User.create({
identity_url: 'langweilig',
email: 'master@example.com', 
firstname: 'wackel', 
lastname: 'dackel',
semester: 4,
academic_program: 'Bachelor',
birthday: '1970-12-10',
education:'Abitur',
additional_information: 'No',
homepage: 'www.dieter.de',
github: 'www.github.com/dieter',
facebook: 'www.faceboook.com/dieter',
xing: 'www.xing.com/dieter',
linkedin:'www.linkedin.com/dieter',
languages: Language.where(:name => 'English'),
programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
is_student: true})

User.create({
identity_url: 'was?',
email: 'jack@examlpe.com', 
firstname: 'jack', 
lastname: 'derDepp',
semester: 1,
academic_program: 'Bachelor',
birthday: '1970-12-10',
education:'Abitur',
additional_information: 'No',
homepage: 'www.dieter.de',
github: 'www.github.com/dieter',
facebook: 'www.faceboook.com/dieter',
xing: 'www.xing.com/dieter',
linkedin:'www.linkedin.com/dieter',
languages: Language.where(:name => 'English'),
programming_languages: ProgrammingLanguage.where(:name => ['Java']),
user_status: UserStatus.where(:name => 'no interest').first,
is_student: true})

User.create({
identity_url: 'halo',
email: 'test@example.com', 
firstname: 'Hans', 
lastname: 'Scholl',
semester: 1,
academic_program: 'Master',
birthday: '1970-12-10',
education:'Abitur',
additional_information: 'No',
homepage: 'www.dieter.de',
github: 'www.github.com/dieter',
facebook: 'www.faceboook.com/dieter',
xing: 'www.xing.com/dieter',
linkedin:'www.linkedin.com/dieter',
languages: Language.where(:name => 'English'),
programming_languages: ProgrammingLanguage.where(:name => ['Ruby']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
is_student: true})

Chair.create([{
	name: 'EPIC',
	description: 'Enterprise Platforms and Innovative Concepts',
	head_of_chair: 'Prof. Dr. hc. mul Hasso James Kirk Plattner',
	deputy_id: 1
}])