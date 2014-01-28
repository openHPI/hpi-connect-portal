
# Create Standard Roles
Role.delete_all
Role.create!(name: 'Student', level: 1)
Role.create!(name: 'Staff', level: 2)
Role.create!(name: 'Admin', level: 3)

#Create Standart Job Status
JobStatus.delete_all
JobStatus.create!(name: 'pending')
JobStatus.create!(name: 'open')
JobStatus.create!(name: 'running')
JobStatus.create!(name: 'completed')

Language.delete_all
Language.create!([
	{ name: 'english'},
	{ name: 'german'},
	{ name: 'spanish'},
	{ name: 'french'},
	{ name: 'chinese'}
])

#Create some ProgrammingLanguages
ProgrammingLanguage.delete_all
ProgrammingLanguage.create!([
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
UserStatus.create!([
	{ name: 'jobseeking'},
	{ name: 'employed'},
	{ name: 'employedext'},
	{ name: 'nointerest'},
	{ name: 'alumni'}
])

#Create User as an example deputy for all employers
User.delete_all

User.create!([{
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
	languages_users: LanguagesUser.create!([{language_id: Language.where(:name => ['english']).first.id, skill: '4'}]),
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	programming_languages_users: ProgrammingLanguagesUser.create!([{programming_language_id: ProgrammingLanguage.where(:name => ['Java']).first.id, skill: '4'}]),
	user_status: UserStatus.where(:name => 'employedext').first,
	role: Role.where(:name => 'Student').first
}])
User.create([{
	email: "axel.kroschk@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/axel.kroschk", 
	lastname: "Kroschk", 
	firstname: "Axel", 
	role: Role.where(:name => 'Admin').first	
}])
Employer.delete_all

user = User.new(
	email: "johannes.koch@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/johannes.koch", 
	lastname: "Koch", 
	firstname: "Johannes", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Internet Technologies and Systems",
	description: "The research at the chair of Prof. Dr. Christoph Meinel focuses on investigation of scientific principles, methodes and technologies to design and implement novel Internet technologies and innovative Internet-based IT-systems",
	head: "Christoph Meinel",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "tim.friedrich@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.friedrich", 
	lastname: "Friedrich", 
	firstname: "Tim",
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Human Computer Interaction",
	description: "The Human Computer Interaction group headed by Prof. Dr. Patrick Baudisch is concerned with the design, implementation and evaluation of interaction techniques, devices, and systems. More specifically, we create new ways to interact with small devices, such as mobile phones and very large display devices, such as tables and walls.",
	head: "Patrick Baudisch",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "pascal.reinhardt@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/pascal.reinhardt", 
	lastname: "Reinhardt", 
	firstname: "Pascal", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Computer Graphic Systems",
	description: "The Computer Graphics Systems group headed by Prof. Dr. Jürgen Döllner is concerned with the analysis, planning and construction of computer graphics and multimedia systems. Human-computer communication is the overall context of the group’s work.",
	head: "Jürgen Döllner",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "tim.specht@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.specht", 
	lastname: "Specht", 
	firstname: "Tim",
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "OS and Middleware",
	description: "Prof. Andreas Polze's group Operating Systems and Middleware develops programming paradigms, design patterns and description methods for large, distributed component systems. The group’s work focuses on the integration of middleware with embedded systems and the predictability of their behavior with respect to real-time capability, fault tolerance and safety.",
	head: "Andreas Polze",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "julia.steier@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/julia.steier", 
	lastname: "Steier", 
	firstname: "Julia", 
	role: Role.where(:name => 'Admin').first	
)
employer = Employer.new(
	name: "Business Process Technology",
	description: "The Business Process Technology group headed by Prof. Dr. Mathias Weske is engaged in research on the development of innovative models, methods and techniques and the design and construction of software systems to support knowledge-intensive and flexible business processes. The particular focus is on languages and concepts for modeling such processes.",
	head: "Mathias Weske",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "johanna.appel@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/johanna.appel", 
	lastname: "Appel", 
	firstname: "Johanna", 
	role: Role.where(:name => 'Admin').first	
)
employer = Employer.new(
	name: "Software Architecture",
	description: "The Software Architecture Group, led by Prof. Dr. Robert Hirschfeld, is concerned with fundamental elements and structures of software. Methods and tools are developed for improving the comprehension and design of large complex systems.",
	head: "Robert Hirschfeld",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "dummy1@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dummy1", 
	lastname: "dummy", 
	firstname: "dummy", 
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Information Systems",
	description: "Prof. Dr. Felix Naumann is head of the Information Systems Research Group. The group's research goals are the efficient and effective management of heterogeneous information in large, autonomous systems. These include information integration methods, approaches to information quality and data cleansing, directed information searches and metadata management.",
	head: "Felix Naumann",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "dummy2@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dummy2", 
	lastname: "dummy", 
	firstname: "dummy", 
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Systems Analysis and Modeling",
	description: "Prof. Dr. Holger Giese heads the Systems Analysis and Modeling research group since January 2008. The team focuses on model-driven software development for software-intensive systems. This includes the UML-based specification of flexible systems with samples and components, approaches to the formal verification of these models and approaches to the synthesis of models. The group also looks at the transformations of models, code generation concepts for structure and behavior for models and, in general, the problem of the integration of models in model-driven software development.",
	head: "Holger Giese",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "dummy3@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dummy3", 
	lastname: "dummy", 
	firstname: "dummy", 
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Verwaltung",
	description: "to be done",
	head: "to be done",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "dummy4@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dummy4", 
	lastname: "dummy", 
	firstname: "dummy", 
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "SAP",
	description: "SAP",
	head: "Hasso Plattner",
	deputy: user,
	external: true
)
user.employer = employer
employer.save!
user.save!

user = User.new(
	email: "dummy5@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dummy5", 
	lastname: "dummy", 
	firstname: "dummy", 
	role: Role.where(:name => 'Staff').first	
)
employer = Employer.new(
	name: "Enterprise Platform and Integration Concepts",
	description: "Prof. Dr. Hasso Plattner's research group Enterprise Platform and Integration Concepts (EPIC) focuses on the technical aspects of business software and the integration of different software systems into an overall system to meet customer requirements. This involves studying the conceptual and technological aspects of basic systems and components for business processes. In customer-centered business software development, the focus is on the users. And developing solutions tailored to user needs in a timely manner requires well-designed methods, tools and software platforms.",
	head: "Hasso Plattner",
	deputy: user
)
user.employer = employer
employer.save!
user.save!

JobOffer.delete_all
JobOffer.create!([{
	title: "Touch floor", 
	description: 'The student extends the functionality of the touch floor.', 
	employer: Employer.where(:name => "Human Computer Interaction").first, 
	status: JobStatus.where(:name => "completed").first,
	start_date: Date.current+1, 
	time_effort: 6,
	compensation: 11.50,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

JobOffer.create!([{
	title: "Website Developer", 
	description: 'The student develops a wonderful website.', 
	employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+2, 
	time_effort: 9,
	compensation: 13.50,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Ruby']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])

JobOffer.create!([{
	title: "tele-Task developer", 
	description: 'The Job includes the development of new features for tele-Task', 
	employer: Employer.where(:name => "Internet Technologies and Systems").first, 
	start_date: Date.current+3, 
	status: JobStatus.where(:name => "completed").first,
	time_effort: 10,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Frank").first
}])

JobOffer.create!([{
	title: "Tutor for Operating systems", 
	description: 'You have to control the assignments for the Operating Systems I lecture.', 
	employer: Employer.where(:name => "OS and Middleware").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+3, 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++', 'Java']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])


JobOffer.create!([{
	title: "Teleboard Developer", 
	description: 'You have to develop the Teleboard with HTML5 and Javascript', 
	employer: Employer.where(:name => "Internet Technologies and Systems").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+6, 
	time_effort: 5,
	compensation: 12.00,
	languages: Language.where(:name => ['german', 'english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java']),
	responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first
}])


JobOffer.create!([{
	title: "HCI TA", 
	description: 'The job includes preparing the framework for HCI I class, control the assignments and be present at every lecture', 
	employer: Employer.where(:name => "Human Computer Interaction").first, 
	start_date: Date.current+8, 
	time_effort: 20,
	status: JobStatus.where(:name => "working").first,
	compensation: 12.00,
	languages: Language.where(:name	 => ['english']), 
	programming_languages: ProgrammingLanguage.where(:name => ['C++']),
	responsible_user: User.where(:firstname=>'Frank').first
}])

JobOffer.create!([{
	title: "Supporting the lab operations of the chair", 
	description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
	employer: Employer.where(:name => "OS and Middleware").first,
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+100, 
	time_effort: 8,
	compensation: 10.00,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk']),
	responsible_user: User.where(:firstname=>'Frank').first
}])

Faq.delete_all
Faq.create!([{
	question: "How do I make edits to my profile?", 
	answer: 'Log in to your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button.'
}])
Faq.create!([{
	question: "How do I log off of HPI-HiWi-Portal?", 
	answer: 'To logout of your account hover over the Sign Out option in the upper right hand corner of the page.'
}])
Faq.create!([{
	question: "How can I add a profile photo?", 
	answer: 'Log into your account. Then hover over "My Profile" at the top right of the page. Choose the Edit-Button. Search for Foto. Click Browse and select the photo you would like to use for your profile. Click Update Student.'
}])
Faq.create!([{
	question: "Does HPI-HiWi-Portal have an Android app?",
	answer: "No, the HPI-HiWi-Portal does not have an Android app."
}])

Employer.where(name: "Enterprise Platform and Integration Concepts").first.update(deputy: User.where(email: "axel.kroschk@student.hpi.uni-potsdam.de").first)
