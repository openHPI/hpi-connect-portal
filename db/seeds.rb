# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Standard Roles
Role.delete_all
Role.create(name: 'Student', level: 1)
Role.create(name: 'Research Assistant', level: 2)
Role.create(name: 'Admin', level: 3)

#Create Standart Job Status
JobStatus.delete_all
JobStatus.create(name: 'pending')
JobStatus.create(name: 'open')
JobStatus.create(name: 'working')
JobStatus.create(name: 'completed')

#Create User as an example deputy for all chairs
User.delete_all
User.create([{
		firstname: "Chief",
		lastname: "Smith",
		email: "chief@smith.de",
	   	role: Role.where(:name => 'Student').first
	}])

#Create some Languages
Language.delete_all
Language.create([
	{ name: 'Englisch'},
	{ name: 'Deutsch'},
	{ name: 'Spanisch'},
	{ name: 'Französisch'},
	{ name: 'Chinesisch'}
])

#Create some ProgrammingLanguages
ProgrammingLanguage.delete_all
ProgrammingLanguage.create([
	{ name: 'Ruby'},
	{ name: 'Java'},
	{ name: 'C'},
	{ name: 'C++'},
	{ name: 'Python'},
	{ name: 'Smalltalk'}
])

#Create some UserStatus
UserStatus.delete_all
UserStatus.create([
	{ name: 'job-seeking'},
	{ name: 'employed'},
	{ name: 'employed (ext)'},
	{ name: 'no interest'},
	{ name: 'alumni'}
])


#Create User as an example deputy for all chairs
User.delete_all
User.create([{
		firstname: "Chief",
		lastname: "Smith",
		email: "chief@smith.de",
	   	role: Role.where(:name => 'Research Assistant').first,
	   	is_student: false
	}])

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
languages: Language.where(:name => 'Englisch'),
programming_languages: ProgrammingLanguage.where(:name => ['Java']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
is_student: false,
role: Role.where(:name => 'Admin').first}])

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
role: Role.where(:name => 'Student').first,
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
languages: Language.where(:name => 'Englisch'),
programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
role: Role.where(:name => 'Student').first,
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
languages: Language.where(:name => 'Englisch'),
programming_languages: ProgrammingLanguage.where(:name => ['Java']),
user_status: UserStatus.where(:name => 'no interest').first,
role: Role.where(:name => 'Student').first,
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
languages: Language.where(:name => 'Englisch'),
programming_languages: ProgrammingLanguage.where(:name => ['Ruby']),
user_status: UserStatus.where(:name => 'employed (ext)').first,
role: Role.where(:name => 'Student').first,
is_student: true})

Chair.delete_all
Chair.create([{
	name: "Enterprise Platform and Integration Concepts",
	description: "Prof. Dr. Hasso Plattner's research group Enterprise Platform and Integration Concepts (EPIC) focuses on the technical aspects of business software and the integration of different software systems into an overall system to meet customer requirements. This involves studying the conceptual and technological aspects of basic systems and components for business processes. In customer-centered business software development, the focus is on the users. And developing solutions tailored to user needs in a timely manner requires well-designed methods, tools and software platforms.",
	head_of_chair: "Hasso Plattner",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Internet Technologies and Systems",
	description: "The research at the chair of Prof. Dr. Christoph Meinel focuses on investigation of scientific principles, methodes and technologies to design and implement novel Internet technologies and innovative Internet-based IT-systems",
	head_of_chair: "Christoph Meinel",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Human Computer Interaction",
	description: "The Human Computer Interaction group headed by Prof. Dr. Patrick Baudisch is concerned with the design, implementation and evaluation of interaction techniques, devices, and systems. More specifically, we create new ways to interact with small devices, such as mobile phones and very large display devices, such as tables and walls.",
	head_of_chair: "Patrick Baudisch",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Computer Graphic Systems",
	description: "The Computer Graphics Systems group headed by Prof. Dr. Jürgen Döllner is concerned with the analysis, planning and construction of computer graphics and multimedia systems. Human-computer communication is the overall context of the group’s work.",
	head_of_chair: "Jürgen Döllner",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "OS and Middleware",
	description: "Prof. Andreas Polze's group Operating Systems and Middleware develops programming paradigms, design patterns and description methods for large, distributed component systems. The group’s work focuses on the integration of middleware with embedded systems and the predictability of their behavior with respect to real-time capability, fault tolerance and safety.",
	head_of_chair: "Andreas Polze",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Business Process Technology",
	description: "The Business Process Technology group headed by Prof. Dr. Mathias Weske is engaged in research on the development of innovative models, methods and techniques and the design and construction of software systems to support knowledge-intensive and flexible business processes. The particular focus is on languages and concepts for modeling such processes.",
	head_of_chair: "Mathias Weske",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Software Architecture",
	description: "The Software Architecture Group, led by Prof. Dr. Robert Hirschfeld, is concerned with fundamental elements and structures of software. Methods and tools are developed for improving the comprehension and design of large complex systems.",
	head_of_chair: "Robert Hirschfeld",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Information Systems",
	description: "Prof. Dr. Felix Naumann is head of the Information Systems Research Group. The group's research goals are the efficient and effective management of heterogeneous information in large, autonomous systems. These include information integration methods, approaches to information quality and data cleansing, directed information searches and metadata management.",
	head_of_chair: "Felix Naumann",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Systems Analysis and Modeling",
	description: "Prof. Dr. Holger Giese heads the Systems Analysis and Modeling research group since January 2008. The team focuses on model-driven software development for software-intensive systems. This includes the UML-based specification of flexible systems with samples and components, approaches to the formal verification of these models and approaches to the synthesis of models. The group also looks at the transformations of models, code generation concepts for structure and behavior for models and, in general, the problem of the integration of models in model-driven software development.",
	head_of_chair: "Holger Giese",
	deputy: User.where(:firstname=>"Chief").first
}])

Chair.create([{
	name: "Systems Analysis and Modeling",
	description: "Prof. Dr. Holger Giese heads the Systems Analysis and Modeling research group since January 2008. The team focuses on model-driven software development for software-intensive systems. This includes the UML-based specification of flexible systems with samples and components, approaches to the formal verification of these models and approaches to the synthesis of models. The group also looks at the transformations of models, code generation concepts for structure and behavior for models and, in general, the problem of the integration of models in model-driven software development.",
	head_of_chair: "Holger Giese",
	deputy: User.where(:firstname=>"Chief").first
}])

JobOffer.delete_all
JobOffer.create([{
	title: "Touch floor", 
	description: 'The student extends the functionality of the touch floor.', 
	chair: Chair.where(:name => "Human Computer Interaction").first, 
	status: JobStatus.where(:name => "completed").first,
	start_date: '2013-11-01', 
	time_effort: 6,
	compensation: 11.50,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
	responsible_user: User.where(:firstname=>"Chief").first
}])

JobOffer.create([{
	title: "Website Developer", 
	description: 'The student develops a wonderful website.', 
	chair: Chair.where(:name => "Enterprise Platform and Integration Concepts").first, 
	status: JobStatus.where(:name => "completed").first,
	start_date: '2013-10-01', 
	time_effort: 9,
	compensation: 13.50,
	languages: Language.where(:name => 'Deutsch'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Ruby']),
	responsible_user: User.where(:firstname=>"Chief").first
}])

JobOffer.create([{
	title: "tele-Task developer", 
	description: 'The Job includes the development of new features for tele-Task', 
	chair: Chair.where(:name => "Internet Technologies and Systems").first, 
	start_date: '2013-11-11', 
	status: JobStatus.where(:name => "completed").first,
	time_effort: 10,
	compensation: 12.00,
	languages: Language.where(:name => ['German', 'English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Chief").first
}])

JobOffer.create([{
	title: "Tutor for Operating systems", 
	description: 'You have to control the assignments for the Operating Systems I lecture.', 
	chair: Chair.where(:name => "OS and Middleware").first, 
	start_date: '2013-12-01', 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['German', 'English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++', 'Java']),
	responsible_user: User.where(:firstname=>"Chief").first
}])


JobOffer.create([{
	title: "Teleboard Developer", 
	description: 'You have to develop the Teleboard with HTML5 and Javascript', 
	chair: Chair.where(:name => "Internet Technologies and Systems").first, 
	start_date: '2013-12-12', 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['German', 'English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Chief").first
}])


JobOffer.create([{
	title: "HCI TA", 
	description: 'The job includes preparing the framework for HCI I class, control the assignments and be present at every lecture', 
	chair: Chair.where(:name => "Human Computer Interaction").first, 
	start_date: '2013-12-01', 
	time_effort: 20,
	status: JobStatus.where(:name => "working").first,
	compensation: 12.00,
	languages: Language.where(:name => ['English']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C++']),
	responsible_user: User.where(:firstname=>"Chief").first
}])

JobOffer.create([{
	title: "Supporting the lab operations of the chair", 
	description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
	chair: Chair.where(:name => "OS and Middleware").first,
	start_date: '2014-01-01', 
	time_effort: 8,
	compensation: 10.00,
	languages: Language.where(:name => 'German'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk']),
	responsible_user: User.where(:firstname=>"Chief").first
}])



Chair.create([{
	name: 'EPIC',
	description: 'Enterprise Platforms and Innovative Concepts',
	head_of_chair: 'Prof. Dr. hc. mul Hasso James Kirk Plattner',
	deputy_id: 1
}])
Faq.delete_all
Faq.create([{
	question: "How do I make edits to my profile?", 
	answer: 'Log in to your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button.'
}])
Faq.create([{
	question: "How do I log off of HPI-HiWi-Portal?", 
	answer: 'To logout of your account hover over the Sign Out option in the upper right hand corner of the page.'
}])
Faq.create([{
	question: "How can I add a profile photo?", 
	answer: 'Log into your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button. Search for Foto. Click Browse and select the photo you would like to use for your profile. Click Update Student.'
}])
Faq.create([{
	question: "Does HPI-HiWi-Portal have an Android app?", 
	answer: 'Yes, the HPI-HiWi-Portal Android app allows you to stay connected to the premier job search website to discover the latest jobs that meet your needs.'
}])
