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
	{ name: 'externally employed'},
	{ name: 'no interest'},
	{ name: 'alumni'}
])

Employer.delete_all
User.delete_all
epic = Employer.new(
	name: "Enterprise Platform and Integration Concepts",
	description: "Prof. Dr. Hasso Plattner's research group Enterprise Platform and Integration Concepts (EPIC) focuses on the technical aspects of business software and the integration of different software systems into an overall system to meet customer requirements. This involves studying the conceptual and technological aspects of basic systems and components for business processes. In customer-centered business software development, the focus is on the users. And developing solutions tailored to user needs in a timely manner requires well-designed methods, tools and software platforms.",
	head: "Hasso Plattner",
	deputy: nil,
  avatar: File.open(Rails.root.join('public', 'photos', 'original', 'matthias-uflacker.jpg'))
)
#User.where(:firstname=>"Axel").first.update(employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, employment_start_date: Date.today)
epic_deputy = User.new(
	email: "axel.kroschk@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/axel.kroschk", 
	lastname: "Kroschk", 
	firstname: "Axel",
	semester: 7,
	academic_program: "undefined",
	education: "undefined",
	role: Role.where(:name => 'Staff').first,
	employer: epic
)

epic.deputy = epic_deputy
epic_deputy.employment_start_date =  Date.today
epic.save!
epic_deputy.save!

os = Employer.new(
	name: "OS and Middleware",
	description: "Prof. Andreas Polze's group Operating Systems and Middleware develops programming paradigms, design patterns and description methods for large, distributed component systems. The group’s work focuses on the integration of middleware with embedded systems and the predictability of their behavior with respect to real-time capability, fault tolerance and safety.",
	head: "Andreas Polze",
	deputy: nil,
  avatar: File.open(Rails.root.join('public', 'photos', 'original', 'andreas-polze.jpg'))
)
os_deputy = User.new(
	email: "os.chair@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/os.chair", 
	lastname: "Müller", 
	firstname: "Jasper",
	semester: 1,
	academic_program: "undefined",
	education: "undefined",
	role: Role.where(:name => 'Staff').first,
	employer: os
)

os.deputy = os_deputy
os_deputy.employment_start_date =  Date.today
os.save!
os_deputy.save!

dschool = Employer.new(
	name: "HPI School of Design Thinking",
	description: "At the d.school, we help to create “T-shaped” students. They bring a deep set of skills, knowledge and approach to problem solving from their own field; we help them develop the breadth and creative confidence to collaborate with people from vastly different disciplines. This equips students to tackle the big, ambiguous challenges they’ll encounter out in the world that can’t be solved with a single approach.",
	head: "Uli Weinberg",
	deputy: nil,
  avatar: File.open(Rails.root.join('public', 'photos', 'original', 'uli-weinberg.jpg'))
)
dschool_deputy = User.new(
	email: "dschool.deputy@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/dschool.chair", 
	lastname: "Weinberg", 
	firstname: "Uli",
	role: Role.where(:name => 'Staff').first,
	employer: dschool
)

dschool.deputy = dschool_deputy
dschool_deputy.employment_start_date =  Date.today
dschool.save!
dschool_deputy.save!

sap = Employer.new(
	name: "SAP",
	description: "SAP",
	head: "Hasso Plattner",
	deputy: nil,
	external: true,
  avatar: File.open(Rails.root.join('public', 'photos', 'original', 'hasso-plattner.jpg'))
)
sap_deputy = User.new(
	email: "sap.external@example.com", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/sap.external", 
	lastname: "Jasper", 
	firstname: "Dustin",
	semester: 1,
	academic_program: "undefined",
	education: "undefined",
	role: Role.where(:name => 'Staff').first,
	employer: sap
)

sap.deputy = sap_deputy
sap_deputy.employment_start_date =  Date.today
sap.save!
sap_deputy.save!

# Admin Users

User.create!([{
	email: "tim.specht@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.specht", 
	lastname: "Specht", 
	firstname: "Tim", 
	role: Role.where(:name => 'Admin').first,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-1.jpg'))
}])

# Students

User.create!([{
	email: "julia.steier@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/julia.steier", 
	lastname: "Steier", 
	firstname: "Julia", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-2.jpg'))
}])

User.create!([{
	email: "pascal.reinhardt@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/pascal.reinhardt", 
	lastname: "Reinhardt", 
	firstname: "Pascal", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-3.jpg'))	
}])

User.create!([{
	email: "tim.friedrich@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/tim.friedrich", 
	lastname: "Friedrich", 
	firstname: "Tim",
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-4.jpg'))
}])

User.create!([{
	email: "johannes.koch@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/johannes.koch", 
	lastname: "Koch", 
	firstname: "Johannes", 
	semester: 5,
	academic_program: 'Bachelor',
	education:'Abitur',
	role: Role.where(:name => 'Student').first,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-1.jpg'))
}])

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
	role: Role.where(:name => 'Staff').first,
	employer: epic,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-3.jpg'))
}])

# Staff

User.create!([{
	email: "johanna.appel@student.hpi.uni-potsdam.de", 
	identity_url: "https://openid.hpi.uni-potsdam.de/user/johanna.appel", 
	lastname: "Appel", 
	firstname: "Johanna", 
	role: Role.where(:name => 'Staff').first,
	employer: epic,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-2.jpg'))
}])

User.create!([{
  email: "carsten.meyer@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/carsten.meyer", 
  lastname: "Meyer", 
  firstname: "Carsten",
  education:'Master',
  semester: 5,
  academic_program: 'Bachelor',
  role: Role.where(:name => 'Staff').first,
  employer: epic,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-2.jpg'))
}])

User.create!([{
  email: "martin.boissier@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/martin.boissier", 
  lastname: "Boissier", 
  firstname: "Martin",
  education:'undefined',
  semester: 1,
  academic_program: 'undefined',
  role: Role.where(:name => 'Staff').first,
  employer: epic,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-1.jpg'))
}])

User.create!([{
  email: "nurith.moersberger@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/nurith.moersberger", 
  lastname: "Moersberger", 
  firstname: "Nurith",
  education:'undefined',
  semester: 1,
  academic_program: 'undefined',
  role: Role.where(:name => 'Staff').first,
  employer: dschool,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-3.jpg')) 
}])

User.create!([{
  email: "ulla.egelhof@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/ulla.egelhof", 
  lastname: "Egelhof", 
  firstname: "Ulla",
  education:'undefined',
  semester: 1,
  academic_program: 'undefined',
  role: Role.where(:name => 'Staff').first,
  employer: dschool,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-3.jpg')) 
}])

User.create!([{
  email: "peter.troeger@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/peter.troeger", 
  lastname: "Tröger", 
  firstname: "Dr. Peter",
  education:'undefined',
  semester: 1,
  academic_program: 'undefined',
  role: Role.where(:name => 'Staff').first,
  employer: os,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-1.jpg')) 
}])

User.create!([{
  email: "sabine.wagner@hpi.uni-potsdam.de", 
  identity_url: "https://openid.hpi.uni-potsdam.de/user/sabine.wagner", 
  lastname: "Wagner", 
  firstname: "Sabine",
  education:'undefined',
  semester: 1,
  academic_program: 'undefined',
  role: Role.where(:name => 'Staff').first,
  employer: os,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-3.jpg'))
}])

JobOffer.delete_all

# EPIC Jobs

JobOffer.create!([{
	title: "HPI Career Portal", 
	description: 'A new carrer portal for the HPI should be developed. External and internal employers (e.h. chairs of the HPI) should be allowed to list different job offers. HPI students should then be offered the possibility to apply for those. Authentication should be done via HPI OpenID, the application itself should be written in Ruby on Rails in an agile environemt including Continous Integration and weekly Scrum meetings.', 
	employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+2, 
	time_effort: 9,
	compensation: 13.50,
	languages: Language.where(:name => 'german'), 
	programming_languages: ProgrammingLanguage.where(:name => ['Ruby']),
	responsible_user: User.where(:firstname=>"Tim", :lastname=>"Specht").first,
    vacant_posts: 1
}])

JobOffer.create!([{
  title: "Genome project", 
  description: 'Using up to date in-memory hardware and tools a genome analysis application shall be developed to assist biological reasearchers worldwide.', 
  employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Python', 'C', 'C++']),
  responsible_user: User.where(:firstname=>"Martin", :lastname=>"Boissier").first,
  vacant_posts: 1
}])

JobOffer.create!([{
  title: "Hyrise Developer", 
  description: 'The HYRISE development team is looking for active and engaged help in further enhancing the chairs expiremental in-memory database HYRISE.', 
  employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
  responsible_user: User.where(:firstname=>"Tim", :lastname=>"Specht").first,
  assigned_students: [User.where(firstname: "Pascal").first],
  vacant_posts: 0
}])

# DSchool Jobs

JobOffer.create!([{
	title: "Research assistant", 
	description: 'For the summer semester 2014 a new research assistant is needed to assist the head of the chair and his fellow researches with their work. Also includes support and supervision of students taking the basic track.', 
	employer: Employer.where(:name => "HPI School of Design Thinking").first, 
	status: JobStatus.where(:name => "open").first,
	start_date: Date.current+1, 
	time_effort: 12,
	compensation: 10.0,
	languages: Language.where(:name => 'german'), 
	responsible_user: User.where(:firstname=>"Frank", :lastname=>"Blechschmidt").first,
    vacant_posts: 1
}])

JobOffer.create!([{
  title: "Post graduate", 
  description: 'Starting May 2014 the HPI School of Design Thinking is looking for a post-graduate former HPI student to join the chair.', 
  employer: Employer.where(:name => "HPI School of Design Thinking").first, 
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+1, 
  time_effort: 38,
  compensation: 14.0,
  languages: Language.where(:name => 'german'), 
  responsible_user: User.where(:firstname=>"Frank", :lastname=>"Blechschmidt").first,
  vacant_posts: 1
}])

JobOffer.create!([{
  title: "Visitor Attendant", 
  description: 'The HPI School of Design Thinking is looking for someone to attend the miscellaneous vistors coming to visit the school. Includes show-arounds and introductions to Design Thinking.', 
  employer: Employer.where(:name => "HPI School of Design Thinking").first, 
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+1, 
  time_effort: 38,
  compensation: 14.0,
  languages: Language.where(:name => 'english'), 
  responsible_user: User.where(:firstname=>"Axel", :lastname=>"Kroschk").first,
  assigned_students: [User.where(firstname: "Frank").first],
  vacant_posts: 0
}])

# OS Jobs

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
	responsible_user: User.where(:firstname=>"Carsten", :lastname=>"Meyer").first,
    vacant_posts: 1
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
	responsible_user: User.where(:firstname=>'Frank').first,
    vacant_posts: 1
}])

JobOffer.create!([{
  title: "OpenHPI supporter", 
  description: 'The chair is looking for someone to correct the handed-in exercises for the upcoming OpenHPI-cource on Parallel Computing.', 
  employer: Employer.where(:name => "OS and Middleware").first,
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+100, 
  time_effort: 8,
  compensation: 10.00,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python']),
  responsible_user: User.where(:firstname=>'Frank').first,
  assigned_students: [User.where(firstname: "Johannes").first],
  vacant_posts: 0
}])

# SAP jobs

JobOffer.create!([{
  title: "HANA developer", 
  description: 'A developer for SAPs leading in-memory database HANA is needed. Strong teamskills required.', 
  employer: Employer.where(:name => "SAP").first,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+100, 
  time_effort: 38,
  compensation: 20.00,
  languages: Language.where(:name => 'english'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C']),
  responsible_user: User.where(:firstname=>'Carsten').first,
  vacant_posts: 1
}])

JobOffer.create!([{
  title: "Business by design", 
  description: 'A senior software architect for enhancing the SAP Business by Design programm is needed.', 
  employer: Employer.where(:name => "SAP").first,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+100, 
  time_effort: 40,
  compensation: 60.00,
  languages: Language.where(:name => 'english'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C']),
  responsible_user: User.where(:firstname=>'Carsten').first,
  vacant_posts: 1
}])

JobOffer.create!([{
  title: "HR Recruiter", 
  description: 'To further fullfill the SAPs personal needs a additional teammate for the HR team is seeked.', 
  employer: Employer.where(:name => "SAP").first,
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+100, 
  time_effort: 40,
  compensation: 24.00,
  languages: Language.where(:name => 'english'),
  responsible_user: User.where(:firstname=>'Martin').first,
  assigned_students: [User.where(firstname: "Tim").first],
  vacant_posts: 0
}])

# FAQs

Faq.delete_all
Faq.create!([{
	question: "How do I make edits to my profile?", 
	answer: 'Log in to your account. Then hover over "My profile" at the top right of the page. Choose the Edit-Button.',
	locale: "en"
}])
Faq.create!([{
	question: "How do I log off of HPI-HiWi-Portal?", 
	answer: 'To logout of your account hover over the Sign Out option in the upper right hand corner of the page.',
	locale: "en"
}])
Faq.create!([{
	question: "How can I add a profile photo?", 
	answer: 'Log into your account. Then hover over "My profile" at the top right of the page. Choose the Edit-Button. Search for Foto. Click Browse and select the photo you would like to use for your profile. Click Update Student.',
	locale: "en"
}])
Faq.create!([{
	question: "Does HPI-HiWi-Portal have an Android app?",
	answer: "No, the HPI-HiWi-Portal does not have an Android app.",
	locale: "en"
}])
Faq.create!([{
	question: "Wie kann ich mein Profile bearbeiten?", 
	answer: 'Melden Sie sich mit Ihrem Account an. Klicken Sie dann auf "Mein Profil" in der rechten oberen Ecke und wählen den "Bearbeiten"-Button.',
	locale: "de"
}])
Faq.create!([{
	question: "Wie kann ich mich am HPI-HiWi-Portal ausloggen?", 
	answer: 'Bitte klicken Sie den "Ausloggen"-Button in der rechten oberen Bildschirmecke.',
	locale: "de"
}])
Faq.create!([{
	question: "Wie kann ich mein Profil-Foto bearbeiten?", 
	answer: 'Melden Sie sich mit Ihrem Account an. Klicken Sie dann auf "Mein Profil" in der rechten oberen Ecke und wählen den "Bearbeiten"-Button Search for Foto. Wählen Sie nun das gewünschte Foto aus, und klicken abschließend auf "Aktualisieren".',
	locale: "de"
}])
Faq.create!([{
	question: "Hat das HPI-HiWi-Portal eine Android-App?", 
	answer: 'Ja, die HPI-HiWi-Portal Android-App ermöglicht es Ihnen, über alle für Sie passenden Stellenangebote am HPI auf dem Laufenden zu bleiben.',
	locale: "de"
}])
