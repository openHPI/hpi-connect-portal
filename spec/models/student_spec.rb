# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  semester               :integer
#  academic_program       :string(255)
#  birthday               :date
#  education              :text
#  additional_information :text
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :datetime
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :datetime
#

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
