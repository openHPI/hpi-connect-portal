require 'spec_helper'

describe Student do
  
  before :each do
  	@student = FactoryGirl.build(:student)

  	Student.create!([{
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
	languages: Language.create([{name: 'Englisch'}]), 
	programming_languages: ProgrammingLanguage.create([{ name: 'Ruby'}])
}])
  end

  describe "#new" do
  	it "returns a new student object" do
  		@student.should be_an_instance_of Student
  	end

  end

#   describe "#searchStudentsByProgrammingLanguage" do

#   	it "returns an array of students how speak a ProgrammingLanguage" do
#   	student = Student.create!([{
# 	first_name: 'Jasper', 
# 	last_name: 'Schulze', 
# 	semester: '5', 
# 	academic_program: 'Bachelor', 
# 	birthday: '1970-12-10', 
# 	education: 'Abitur', 
# 	additional_information: 'No', 
# 	homepage: 'www.dieter.de', 
# 	github: 'www.github.com/dieter', 
# 	facebook: 'www.faceboook.com/dieter', 
# 	xing: 'www.xing.com/dieter', 
# 	linkedin: 'www.linkedin.com/dieter', 
# 	languages: Language.create([{name: 'Englisch'}]), 
# 	programming_languages: ProgrammingLanguage.create([{ name: 'Ruby'}])
# }])
#   	  	pp Student.searchStudentsByProgrammingLanguage('Ruby')
#   	expect(Student.searchStudentsByProgrammingLanguage('Ruby')).to include (Student.find_by(first_name: 'Jasper'))
#   	end
#   end
#   after(:all) do
#   	Language.delete_all
#   	ProgrammingLanguage.delete_all
#   end

end
