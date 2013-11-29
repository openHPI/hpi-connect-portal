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

  describe "#checkTypeOfPhoto" do

    it "accepts a jpeg image" do
      # no working version found

      
      #@student.photo = File.new("spec/fixtures/pdf/test_cv.pdf")
      #@student.photo = File.new("spec/fixtures/images/test_picture.jpg")
      #expect(@student.photo.path).should eq("bla")

      #expect(FileTest.exists?(@student.photo.path)).should eq(@student.photo)
    end
  end

  describe "#searchStudentsByProgrammingLanguage" do

  	it "returns an array of students who speak a ProgrammingLanguage" do
   	expect(Student.search_students_by_programming_language('Ruby')).to include @student
  	end
  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.search_students_by_programming_language("Hindi")).should eq([])
  	end
  end

  describe"#searchStudentsByLanguage" do
  	it "returns an array of students who speak a language"do
  		expect(Student.search_students_by_language('Englisch')).to include(@student)
  	end

  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.search_students_by_language("Hindi")).should eq([])
  	end
  end

  describe"#search_students_by_language_and_programming_language" do
    it "should return all students who speak the language german AND know the programming language php" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:student, programming_languages: [php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [php], languages: [english])
      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german, english])

      matching_students = Student.search_students_by_language_and_programming_language(["german"], ["php"])
      assert_equal(matching_students.length, 3);
    end

    it "should return all students who speak the language german AND" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:student, programming_languages: [php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [php], languages: [english])
      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german, english])


      matching_students = Student.search_students_by_language_and_programming_language(["german"], [])
      assert_equal(matching_students.length, 4);
    end

    it "should return all students who know the languages php AND java" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:student, programming_languages: [php], languages: [german])
      FactoryGirl.create(:student, programming_languages: [php], languages: [english])
      FactoryGirl.create(:student, programming_languages: [java, php], languages: [german, english])

      matching_students = Student.search_students_by_language_and_programming_language([], ["php", "java"])
      assert_equal(matching_students.length, 2);
    end

  end

  describe"#searchStudent" do
  	it "returns an array of students whos description contain a queryed string"do
  		expect(Student.search_student('Englisch')).to include(@student)
  	end
  	it "returns an array of students whos description contain a queryed string"do
  		expect(Student.search_student('Larry')).to include(@student)
  	end

  	it "should return an empty array if anyone speaks the requested language" do
  		expect(Student.search_student("Hindi")).should eq([])
  	end
  end

  after(:all) do
  	Student.delete_all
  	Language.delete_all
  	ProgrammingLanguage.delete_all
  end

end
