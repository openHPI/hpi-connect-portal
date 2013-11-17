# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
