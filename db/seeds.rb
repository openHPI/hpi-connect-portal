# Create Standard Roles
Role.delete_all
Role.create!(name: 'Student', level: 1)
Role.create!(name: 'Staff', level: 2)
Role.create!(name: 'Admin', level: 3)

#Create Standart Job Status
JobStatus.delete_all
JobStatus.create!(name: 'pending')
JobStatus.create!(name: 'active')
JobStatus.create!(name: 'closed')

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

Contact.delete_all
#Contact.create!(
#counterpart_id: 0,
#counterpart_type: "employer", 
#name: "Hasso Plattner", 
#street: "Prof. Dr. Helmert Straße 2-3",
#zip_city: "14482 Potsdam",
#email: "plattner@hpi.de",
#phone: "01000000"
#  )

Employer.delete_all
User.delete_all
Student.delete_all
Staff.delete_all


hpi = Employer.create!(
  booked_package_id: Employer::PACKAGES.index("premium"),
  requested_package_id: Employer::PACKAGES.index("premium"),
  name: "Hasso-Plattner-Institut",
  activated: true,
  description: "This is the Hasso-Plattner-Institut.",
  number_of_employees: "50-100",
  place_of_business: "Potsdam - Brandenburg",
  line_of_business: "IT",
  website: "http://www.hpi.uni-potsdam.de",
  year_of_foundation: 1998,
    avatar: File.open(Rails.root.join('public', 'photos', 'original', 'matthias-uflacker.jpg'))
)
hpi_staff = Staff.create!(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "axel.kroschk@student.hpi.uni-potsdam.de", 
    lastname: "Kroschk", 
    firstname: "Axel",
  ),
  employer: hpi
)

sap = Employer.create!(
  booked_package_id: Employer::PACKAGES.index("premium"),
  requested_package_id: Employer::PACKAGES.index("premium"),
  name: "SAP",
  activated: true,
  description: "SAP",
  number_of_employees: ">1000",
  place_of_business: "Baden-Württemberg",
  line_of_business: "IT",
  website: "http://www.sap.de",
  year_of_foundation: 1972,
    avatar: File.open(Rails.root.join('public', 'photos', 'original', 'hasso-plattner.jpg'))
)
sap_staff = Staff.create!(
  user: User.new(
    password: 'password',
    password_confirmation: 'password',
    email: "claudia.koch@hpi.uni-potsdam.de", 
    lastname: "Koch", 
    firstname: "Claudia"
  ),
  employer: sap
)

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
  academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor"),
  graduation_id: Student::GRADUATIONS.index("abitur"),
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
  employer: hpi,
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
  employer: hpi,
}])

JobOffer.delete_all

# EPIC Jobs

JobOffer.create!([{
  title: "HPI Career Portal", 
  description: 'A new carrer portal for the HPI should be developed. External and internal employers (e.h. chairs of the HPI) should be allowed to list different job offers. HPI students should then be offered the possibility to apply for those. Authentication should be done via HPI OpenID, the application itself should be written in Ruby on Rails in an agile environemt including Continous Integration and weekly Scrum meetings.', 
  state_id: 0,
  category_id: 1,
  graduation_id: 3,
  employer: hpi, 
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+2, 
  time_effort: 9,
  compensation: 13.50,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Ruby']),
}])

JobOffer.create!([{
  title: "Genome project", 
  description: 'Using up to date in-memory hardware and tools a genome analysis application shall be developed to assist biological reasearchers worldwide.', 
  state_id: 2,
  category_id: 1,
  graduation_id: 3,
  employer: hpi, 
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Python', 'C', 'C++'])
}])

JobOffer.create!([{
  title: "Hyrise Developer", 
  description: 'The HYRISE development team is looking for active and engaged help in further enhancing the chairs expiremental in-memory database HYRISE.', 
  state_id: 3,
  category_id: 2,
  graduation_id: 4,
  employer: hpi, 
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+15, 
  time_effort: 38,
  compensation: 12.0,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++']),
  assigned_students: [User.where(firstname: "Pascal").first.manifestation]
}])

# OS Jobs

JobOffer.create!([{
  title: "Tutor for Operating systems", 
  description: 'You have to control the assignments for the Operating Systems I lecture.', 
  state_id: 6,
  category_id: 0,
  graduation_id: 1,
  employer: hpi, 
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+3, 
  time_effort: 5,
  compensation: 12.00,
  languages: Language.where(:name => ['german', 'english']), 
  programming_languages: ProgrammingLanguage.where(:name => ['C', 'C++', 'Java'])
}])


JobOffer.create!([{
  title: "Supporting the lab operations of the chair", 
  description: 'We want you to help in implementing a new modeling tool designed for embedded systems', 
  state_id: 0,
  category_id: 0,
  graduation_id: 0,
  employer: hpi,
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+100, 
  time_effort: 8,
  compensation: 10.00,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python', 'Smalltalk'])
}])

JobOffer.create!([{
  title: "OpenHPI supporter", 
  description: 'The chair is looking for someone to correct the handed-in exercises for the upcoming OpenHPI-cource on Parallel Computing.', 
  state_id: 4,
  category_id: 3,
  graduation_id: 3,
  employer: hpi,
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+100, 
  time_effort: 8,
  compensation: 10.00,
  languages: Language.where(:name => 'german'), 
  programming_languages: ProgrammingLanguage.where(:name => ['Java', 'Python']),
  assigned_students: [User.where(firstname: "Frank").first.manifestation]
}])

# SAP jobs

JobOffer.create!([{
  title: "HANA developer", 
  description: 'A developer for SAPs leading in-memory database HANA is needed. Strong teamskills required.', 
  state_id: 1,
  category_id: 1,
  graduation_id: 3,
  employer: hpi,
  status: JobStatus.where(:name => "active").first,
  start_date: Date.current+100, 
  time_effort: 38,
  compensation: 20.00,
  languages: Language.where(:name => 'english'), 
  programming_languages: ProgrammingLanguage.where(:name => ['C'])
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
