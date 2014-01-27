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
Role.create(name: 'Staff', level: 2)
Role.create(name: 'Admin', level: 3)

#Create Standart Job Status
JobStatus.delete_all
JobStatus.create(name: 'pending')
JobStatus.create(name: 'open')
JobStatus.create(name: 'running')
JobStatus.create(name: 'completed')

Language.delete_all
Language.create([
	{ name: 'english'},
	{ name: 'german'},
	{ name: 'spanish'},
	{ name: 'french'},
	{ name: 'chinese'}
])

#Create some ProgrammingLanguages
ProgrammingLanguage.delete_all
ProgrammingLanguage.create([
	{ name: 'C'},
	{ name: 'C++'},
	{ name: 'C#'},
	{ name: 'Java'},
	{ name: 'Objective-C'},
	{ name: 'PHP'},
	{ name: 'Python'},
	{ name: 'SQL'},
	{ name: 'JavaScript'},
	{ name: 'Ruby'},
	{ name: 'SmallTalk'},
	{ name: 'Prolog'},
	{ name: 'Scheme'},
	{ name: 'Lisp'},
	{ name: 'Closure'},
	{ name: 'Django'},
	{ name: 'Rails'},
	{ name: 'OpenGL'}
])

UserStatus.delete_all
UserStatus.create([
	{ name: 'jobseeking'},
	{ name: 'employed'},
	{ name: 'employedext'},
	{ name: 'nointerest'},
	{ name: 'alumni'}
])

#Create User as an example deputy for all chairs
User.delete_all
User.create([{
	email: "axel.kroschk@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/axel.kroschk", 
	lastname: "Kroschk", 
	firstname: "Axel", 
	role: Role.where(:name => 'Staff').first	
}])

User.create([{
	email: "tim.specht@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.specht", 
	lastname: "Specht", 
	firstname: "Tim",
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
	email: "pascal.reinhardt@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/pascal.reinhardt", 
	lastname: "Reinhardt", 
	firstname: "Pascal", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
	email: "tim.friedrich@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.friedrich", 
	lastname: "Friedrich", 
	firstname: "Tim",
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
	email: "johannes.koch@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/johannes.koch", 
	lastname: "Koch", 
	firstname: "Johannes", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
	email: "max.mustermann@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/max.mustermann", 
	lastname: "Mustermann", 
	firstname: "Max", 
	semester: 3,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
	email: "erika.mustermann@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/erika.mustermann", 
	lastname: "Mustermann", 
	firstname: "Erika", 
	semester: 3,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first	
}])

User.create([{
identity_url: 'https://openid.hpi.uni-potsdam.de/user/frank.blechschmidt',
email: 'frank.blechschmidt@example.com', 
firstname: 'Frank', 
lastname: 'Blechschmidt',
semester: 5,
academic_program: 'Bachelor',
birthday: '1990-12-30',
education:'Abitur',
additional_information: 'Bachelorprojekt: Modern Computer-aided Software Engineering',
homepage: 'https://twitter.com/FraBle90',
github: 'https://github.com/FraBle',
facebook: 'https://www.facebook.com/FraBle90',
xing: 'https://www.xing.com/profiles/Frank_Blechschmidt4',
linkedin:'http://www.linkedin.com/pub/frank-blechschmidt/34/bab/ab4',
languages: Language.where(:name => ['english']),
languages_users: LanguagesUser.create([{language_id: Language.where(:name => ['english']).first.id, skill: '4'}]),
programming_languages: ProgrammingLanguage.where(:name => ['Java']),
programming_languages_users: ProgrammingLanguagesUser.create([{programming_language_id: ProgrammingLanguage.where(:name => ['Java']).first.id, skill: '4'}]),
user_status: UserStatus.where(:name => 'employedext').first,
role: Role.where(:name => 'Student').first
}])

Chair.delete_all
Chair.create([{
	name: "Enterprise Platform and Integration Concepts",
	description: "Prof. Dr. Hasso Plattner's research group Enterprise Platform and Integration Concepts (EPIC) focuses on the technical aspects of business software and the integration of different software systems into an overall system to meet customer requirements. This involves studying the conceptual and technological aspects of basic systems and components for business processes. In customer-centered business software development, the focus is on the users. And developing solutions tailored to user needs in a timely manner requires well-designed methods, tools and software platforms.",
	head_of_chair: "Hasso Plattner",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])
User.where(:firstname=>"Axel").first.update(chair: Chair.where(:name => "Enterprise Platform and Integration Concepts").first, employment_start_date: Date.today)

Chair.create([{
	name: "Internet Technologies and Systems",
	description: "The research at the chair of Prof. Dr. Christoph Meinel focuses on investigation of scientific principles, methodes and technologies to design and implement novel Internet technologies and innovative Internet-based IT-systems",
	head_of_chair: "Christoph Meinel",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Human Computer Interaction",
	description: "The Human Computer Interaction group headed by Prof. Dr. Patrick Baudisch is concerned with the design, implementation and evaluation of interaction techniques, devices, and systems. More specifically, we create new ways to interact with small devices, such as mobile phones and very large display devices, such as tables and walls.",
	head_of_chair: "Patrick Baudisch",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Computer Graphic Systems",
	description: "The Computer Graphics Systems group headed by Prof. Dr. Jürgen Döllner is concerned with the analysis, planning and construction of computer graphics and multimedia systems. Human-computer communication is the overall context of the group’s work.",
	head_of_chair: "Jürgen Döllner",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "OS and Middleware",
	description: "Prof. Andreas Polze's group Operating Systems and Middleware develops programming paradigms, design patterns and description methods for large, distributed component systems. The group’s work focuses on the integration of middleware with embedded systems and the predictability of their behavior with respect to real-time capability, fault tolerance and safety.",
	head_of_chair: "Andreas Polze",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Business Process Technology",
	description: "The Business Process Technology group headed by Prof. Dr. Mathias Weske is engaged in research on the development of innovative models, methods and techniques and the design and construction of software systems to support knowledge-intensive and flexible business processes. The particular focus is on languages and concepts for modeling such processes.",
	head_of_chair: "Mathias Weske",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Software Architecture",
	description: "The Software Architecture Group, led by Prof. Dr. Robert Hirschfeld, is concerned with fundamental elements and structures of software. Methods and tools are developed for improving the comprehension and design of large complex systems.",
	head_of_chair: "Robert Hirschfeld",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Information Systems",
	description: "Prof. Dr. Felix Naumann is head of the Information Systems Research Group. The group's research goals are the efficient and effective management of heterogeneous information in large, autonomous systems. These include information integration methods, approaches to information quality and data cleansing, directed information searches and metadata management.",
	head_of_chair: "Felix Naumann",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Systems Analysis and Modeling",
	description: "Prof. Dr. Holger Giese heads the Systems Analysis and Modeling research group since January 2008. The team focuses on model-driven software development for software-intensive systems. This includes the UML-based specification of flexible systems with samples and components, approaches to the formal verification of these models and approaches to the synthesis of models. The group also looks at the transformations of models, code generation concepts for structure and behavior for models and, in general, the problem of the integration of models in model-driven software development.",
	head_of_chair: "Holger Giese",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

Chair.create([{
	name: "Verwaltung",
	description: "to be done",
	head_of_chair: "to be done",
	deputy: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
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
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

JobOffer.create([{
	title: "Website Developer", 
	description: 'The student develops a wonderful website.', 
	chair: Chair.where(:name => "Enterprise Platform and Integration Concepts").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: '2013-10-01', 
	time_effort: 9,
	compensation: 13.50,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Ruby']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first,
	assigned_students: [User.where(:firstname=>"Frank", :lastname=>"Blechschmidt").first, User.where(:firstname=>"Max", :lastname=>"Mustermann").first]
}])

JobOffer.create([{
	title: "tele-Task developer", 
	description: 'The Job includes the development of new features for tele-Task', 
	chair: Chair.where(:name => "Internet Technologies and Systems").first, 
	start_date: '2013-11-11', 
	status: JobStatus.where(:name => "completed").first,
	time_effort: 10,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Frank").first,
}])

JobOffer.create([{
	title: "Tutor for Operating systems", 
	description: 'You have to control the assignments for the Operating Systems I lecture.', 
	chair: Chair.where(:name => "OS and Middleware").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: '2013-12-01', 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++', 'Java']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first,
	assigned_students: User.where(:firstname=>['Frank', 'Tim']),
	vacant_posts: 3
}])


JobOffer.create([{
	title: "Teleboard Developer", 
	description: 'You have to develop the Teleboard with HTML5 and Javascript', 
	chair: Chair.where(:name => "Internet Technologies and Systems").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: '2013-12-12', 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first,
	vacant_posts: 2
}])


JobOffer.create([{
	title: "HCI TA", 
	description: 'The job includes preparing the framework for HCI I class, control the assignments and be present at every lecture', 
	chair: Chair.where(:name => "Human Computer Interaction").first, 
	start_date: '2013-12-01', 
	time_effort: 20,
	status: JobStatus.where(:name => "working").first,
	compensation: 12.00,
	languages: Language.where(:name => ['english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C++']),
	responsible_user: User.where(:firstname=>'Frank').first
}])

JobOffer.create([{
	title: "Supporting the lab operations of the chair", 
	description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
	chair: Chair.where(:name => "OS and Middleware").first,
	status: JobStatus.where(:name => "open").first,
	start_date: '2014-01-01', 
	time_effort: 8,
	compensation: 10.00,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk']),
	responsible_user: User.where(:firstname=>'Frank').first
}])

Application.delete_all
Application.create([{
	:user => User.where(:firstname=>'Frank', :lastname => 'Blechschmidt').first,
	:job_offer => JobOffer.where(:title => "Teleboard Developer").first
}])

Application.create([{
	:user => User.where(:firstname=>'Max', :lastname => 'Mustermann').first,
	:job_offer => JobOffer.where(:title => "Teleboard Developer").first
}])

Application.create([{
	:user => User.where(:firstname=>'Erika', :lastname => 'Mustermann').first,
	:job_offer => JobOffer.where(:title => "Teleboard Developer").first
}])

Faq.delete_all
Faq.create([{
	question: "How do I make edits to my profile?", 
	answer: 'Log in to your account. Then hover over "My profile" at the top right of the page. Choose the Edit-Button.',
	locale: "en"
}])
Faq.create([{
	question: "How do I log off of HPI-HiWi-Portal?", 
	answer: 'To logout of your account hover over the Sign Out option in the upper right hand corner of the page.',
	locale: "en"
}])
Faq.create([{
	question: "How can I add a profile photo?", 
	answer: 'Log into your account. Then hover over "My profile" at the top right of the page. Choose the Edit-Button. Search for Foto. Click Browse and select the photo you would like to use for your profile. Click Update Student.',
	locale: "en"
}])
Faq.create([{
	question: "Does HPI-HiWi-Portal have an Android app?", 
	answer: 'Yes, the HPI-HiWi-Portal Android app allows you to stay connected to the premier job search website to discover the latest jobs that meet your needs.',
	locale: "en"
}])
Faq.create([{
	question: "Wie kann ich mein Profile bearbeiten?", 
	answer: 'Melden Sie sich mit Ihrem Account an. Klicken Sie dann auf "Mein Profil" in der rechten oberen Ecke und wählen den "Bearbeiten"-Button.',
	locale: "de"
}])
Faq.create([{
	question: "Wie kann ich mich am HPI-HiWi-Portal ausloggen?", 
	answer: 'Bitte klicken Sie den "Ausloggen"-Button in der rechten oberen Bildschirmecke.',
	locale: "de"
}])
Faq.create([{
	question: "Wie kann ich mein Profil-Foto bearbeiten?", 
	answer: 'Melden Sie sich mit Ihrem Account an. Klicken Sie dann auf "Mein Profil" in der rechten oberen Ecke und wählen den "Bearbeiten"-Button Search for Foto. Wählen Sie nun das gewünschte Foto aus, und klicken abschließend auf "Aktualisieren".',
	locale: "de"
}])
Faq.create([{
	question: "Hat das HPI-HiWi-Portal eine Android-App?", 
	answer: 'Ja, die HPI-HiWi-Portal Android-App ermöglicht es Ihnen, über alle für Sie passenden Stellenangebote am HPI auf dem Laufenden zu bleiben.',
	locale: "de"
}])

Chair.where(name: "Enterprise Platform and Integration Concepts").first.update(deputy: User.where(email: "axel.kroschk@student.hpi.uni-potsdam.de").first)
