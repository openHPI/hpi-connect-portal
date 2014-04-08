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
	{ name: 'french'},     # common languages in school
	{ name: 'spanish'},    
	{ name: 'italian'},    
	{ name: 'portuguese'}, 
	{ name: 'polish'},     
	{ name: 'russian'},    
	{ name: 'swedish'},    # languages of students who studied abroad
	{ name: 'finnish'},
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

Employer.delete_all
User.delete_all
Student.delete_all
Staff.delete_all

epic = Employer.new(
  name: "Enterprise Platform and Integration Concepts",
  description: "Prof. Dr. Hasso Plattner's research group Enterprise Platform and Integration Concepts (EPIC) focuses on the technical aspects of business software and the integration of different software systems into an overall system to meet customer requirements. This involves studying the conceptual and technological aspects of basic systems and components for business processes. In customer-centered business software development, the focus is on the users. And developing solutions tailored to user needs in a timely manner requires well-designed methods, tools and software platforms.",
  head: "Hasso Plattner",
  deputy: nil,
    avatar: File.open(Rails.root.join('public', 'photos', 'original', 'matthias-uflacker.jpg'))
)
epic_deputy = Staff.new(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "axel.kroschk@student.hpi.uni-potsdam.de", 
    lastname: "Kroschk", 
    firstname: "Axel",
  ),
  employer: epic
)

epic.deputy = epic_deputy
epic.save!
epic_deputy.save!

os = Employer.new(
  name: "OS and Middleware",
  description: "Prof. Andreas Polze's group Operating Systems and Middleware develops programming paradigms, design patterns and description methods for large, distributed component systems. The group’s work focuses on the integration of middleware with embedded systems and the predictability of their behavior with respect to real-time capability, fault tolerance and safety.",
  head: "Andreas Polze",
  deputy: nil,
    avatar: File.open(Rails.root.join('public', 'photos', 'original', 'andreas-polze.jpg'))
)
os_deputy = Staff.new(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "os.chair@example.com",
    lastname: "Müller", 
    firstname: "Jasper",
  ),
  employer: os
)

os.deputy = os_deputy
os.save!
os_deputy.save!

dschool = Employer.new(
  name: "HPI School of Design Thinking",
  description: "At the d.school, we help to create “T-shaped” students. They bring a deep set of skills, knowledge and approach to problem solving from their own field; we help them develop the breadth and creative confidence to collaborate with people from vastly different disciplines. This equips students to tackle the big, ambiguous challenges they’ll encounter out in the world that can’t be solved with a single approach.",
  head: "Uli Weinberg",
  deputy: nil,
    avatar: File.open(Rails.root.join('public', 'photos', 'original', 'uli-weinberg.jpg'))
)
dschool_deputy = Staff.new(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "dschool.deputy@example.com",
    lastname: "Weinberg", 
    firstname: "Uli",
  ),
  employer: dschool
)

dschool.deputy = dschool_deputy
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
sap_deputy = Staff.new(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "claudia.koch@hpi.uni-potsdam.de", 
    lastname: "Koch", 
    firstname: "Claudia"
  ),
  employer: sap
)

sap.deputy = sap_deputy
sap.save!
sap_deputy.save!

# Admin Users

User.create!([{
  email: "alexander.ernst@student.hpi.uni-potsdam.de", 
  lastname: "Ernst", 
  firstname: "Alexander",
  password: "admin",
  password_confirmation: "admin",
  admin: true,
  photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-1.jpg'))
}])

# Students
Student.create!([{
  user: User.new(
    email: "pascal.reinhardt@student.hpi.uni-potsdam.de", 
    lastname: "Reinhardt", 
    firstname: "Pascal",
    password: 'password',
    password_confirmation: 'password',
    photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-3.jpg'))  
  ),
  semester: 5,
  academic_program_id: 0,
  graduation_id: 1,
}])

Student.create!([{
  user: User.new(
    email: 'frank.blechschmidt@example.com', 
    firstname: 'Frank', 
    lastname: 'Blechschmidt',
    password: 'password',
    password_confirmation: 'password',
    photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-3.jpg'))
  ),
  semester: 5,
  academic_program_id: 0,
  graduation_id: 2,
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
  employment_status_id: 2
}])

# Staff
Staff.create!([{
  user: User.new( 
    email: "johanna.appel@student.hpi.uni-potsdam.de", 
    lastname: "Appel", 
    firstname: "Johanna",
    password: 'password',
    password_confirmation: 'password',
    photo: File.open(Rails.root.join('public', 'photos', 'original', 'student-2.jpg'))
  ),
  employer: os,
}])

Staff.create!([{
  user: User.new( 
    email: "carsten.meyer@hpi.uni-potsdam.de", 
    lastname: "Meyer", 
    firstname: "Carsten",
    password: 'password',
    password_confirmation: 'password',
    photo: File.open(Rails.root.join('public', 'photos', 'original', 'employee-2.jpg'))
  ),
  employer: epic,
}])

JobOffer.delete_all

# EPIC Jobs

JobOffer.create!([{
  title: "HPI Career Portal", 
  description: 'A new carrer portal for the HPI should be developed. External and internal employers (e.h. chairs of the HPI) should be allowed to list different job offers. HPI students should then be offered the possibility to apply for those. Authentication should be done via HPI OpenID, the application itself should be written in Ruby on Rails in an agile environemt including Continous Integration and weekly Scrum meetings.', 
  employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
  state_id: 0,
  category_id: 1,
  graduation_id: 3,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+2, 
  time_effort: 9,
  compensation: 13.50,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Ruby']),
  responsible_user:  User.where(:firstname=>"Carsten", :lastname=>"Meyer").first.manifestation,
    vacant_posts: 1
}])

JobOffer.create!([{
  title: "Genome project", 
  description: 'Using up to date in-memory hardware and tools a genome analysis application shall be developed to assist biological reasearchers worldwide.', 
  employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
  state_id: 2,
  category_id: 1,
  graduation_id: 3,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Python', 'C', 'C++']),
  responsible_user:  User.where(:firstname=>"Carsten", :lastname=>"Meyer").first.manifestation,
  vacant_posts: 5
}])

JobOffer.create!([{
  title: "Hyrise Developer", 
  description: 'The HYRISE development team is looking for active and engaged help in further enhancing the chairs expiremental in-memory database HYRISE.', 
  employer: Employer.where(:name => "Enterprise Platform and Integration Concepts").first, 
  state_id: 3,
  category_id: 2,
  graduation_id: 4,
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
  responsible_user:  User.where(:firstname=>"Carsten", :lastname=>"Meyer").first.manifestation,
  assigned_students: [User.where(firstname: "Pascal").first.manifestation],
  vacant_posts: 1
}])

# OS Jobs

JobOffer.create!([{
  title: "Tutor for Operating systems", 
  description: 'You have to control the assignments for the Operating Systems I lecture.', 
  employer: Employer.where(:name => "OS and Middleware").first, 
  state_id: 6,
  category_id: 0,
  graduation_id: 1,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+3, 
  time_effort: 5,
  compensation: 12.00,
  languages: Language.where(:name => ['german', 'english']), 
  programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++', 'Java']),
  responsible_user: User.where(:firstname=>"Johanna", :lastname=>"Appel").first.manifestation,
    vacant_posts: 1
}])


JobOffer.create!([{
  title: "Supporting the lab operations of the chair", 
  description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
  employer: Employer.where(:name => "OS and Middleware").first,
  state_id: 0,
  category_id: 0,
  graduation_id: 0,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+100, 
  time_effort: 8,
  compensation: 10.00,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk']),
  responsible_user: User.where(:firstname=>"Johanna", :lastname=>"Appel").first.manifestation,
    vacant_posts: 1
}])

JobOffer.create!([{
  title: "OpenHPI supporter", 
  description: 'The chair is looking for someone to correct the handed-in exercises for the upcoming OpenHPI-cource on Parallel Computing.', 
  employer: Employer.where(:name => "OS and Middleware").first,
  state_id: 4,
  category_id: 3,
  graduation_id: 3,
  status: JobStatus.where(:name => "running").first,
  start_date: Date.current+100, 
  time_effort: 8,
  compensation: 10.00,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python']),
  responsible_user: User.where(:firstname=>"Johanna", :lastname=>"Appel").first.manifestation,
  assigned_students: [User.where(firstname: "Frank").first.manifestation],
  vacant_posts: 1
}])

# SAP jobs

JobOffer.create!([{
  title: "HANA developer", 
  description: 'A developer for SAPs leading in-memory database HANA is needed. Strong teamskills required.', 
  employer: Employer.where(:name => "SAP").first,
  state_id: 1,
  category_id: 1,
  graduation_id: 3,
  status: JobStatus.where(:name => "open").first,
  start_date: Date.current+100, 
  time_effort: 38,
  compensation: 20.00,
  languages: Language.where(:name => 'english'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C']),
  responsible_user: User.where(:firstname=>"Johanna", :lastname=>"Appel").first.manifestation,
  vacant_posts: 1
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
