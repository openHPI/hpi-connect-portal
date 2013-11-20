require 'spec_helper'

describe Student do
  
  before :each do
  	@student = FactoryGirl.create(:student)

  end

  describe "#new" do
  	it "returns a new student object" do
  		@student.should be_an_instance_of Student
  	end

  end

  describe "#searchStudentsByProgrammingLanguage" do

  	it "returns an array of students who speak a ProgrammingLanguage" do
   	expect(Student.searchStudentsByProgrammingLanguage('Ruby')).to include @student
  	end
  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.searchStudentsByProgrammingLanguage("Hindi")).should eq([])
  	end
  end

  describe"#searchStudentsByLanguage" do
  	it "returns an array of students who speak a language"do
  		expect(Student.searchStudentsByLanguage('Englisch')).to include(@student)
  	end

  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.searchStudentsByLanguage("Hindi")).should eq([])
  	end
  end


  describe"#searchStudent" do
  	it "returns an array of students whos description contain a queryed string"do
  		expect(Student.searchStudent('Englisch')).to include(@student)
  	end
  	it "returns an array of students whos description contain a queryed string"do
  		expect(Student.searchStudent('Larry')).to include(@student)
  	end

  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.searchStudent("Hindi")).should eq([])
  	end
  end

  after(:all) do
  	Student.delete_all
  	Language.delete_all
  	ProgrammingLanguage.delete_all
  end

end
