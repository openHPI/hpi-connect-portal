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
