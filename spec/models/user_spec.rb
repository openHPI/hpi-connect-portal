# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  is_student          :boolean
#  lastname            :string(255)
#  firstname           :string(255)
#  role_id             :integer          default(1), not null
#  chair_id            :integer
#

require 'spec_helper'

describe User do
  before(:each) do
    @english = Language.create(:name=>'Englisch')
    @user = FactoryGirl.create(:user)
    @student = FactoryGirl.create(:user, :is_student => true, :languages=>[@english],
      :programming_languages=>[ProgrammingLanguage.create(:name=>'Ruby')])
  end

  subject { @user }

  describe 'applying' do
    before do
      @job_offer = FactoryGirl.create(:joboffer)
      @application = Application.create(user: @user, job_offer: @job_offer)
    end

    it { should be_applied(@job_offer) }
    its(:applications) { should include(@application) }
    its(:job_offers) { should include(@job_offer) }
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
    expect(User.search_students_by_programming_language('Ruby')).to include @student
    end
    it "should return an empty array if anyone speaks the requested language" do
      expect(User.search_students_by_programming_language("Hindi")).to eq([])
    end
  end

  describe"#searchStudentsByLanguage" do
    it "returns an array of students who speak a language" do
      expect(User.search_students_by_language('Englisch')).to include(@student)
    end

    it "should return an empty array if anyone speaks the requested language" do
      expect(User.search_students_by_language("Hindi")).to eq([])
    end
  end

  describe"#search_students_by_language_and_programming_language" do
    it "should return all students who speak the language german AND know the programming language php" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:user, programming_languages: [php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [php], languages: [english])
      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german, english])

      matching_students = User.search_students_by_language_and_programming_language(["german"], ["php"])
      assert_equal(matching_students.length, 3);
    end

    it "should return all students who speak the language german AND" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:user, programming_languages: [php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [php], languages: [english])
      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german, english])


      matching_students = User.search_students_by_language_and_programming_language(["german"], [])
      assert_equal(matching_students.length, 4);
    end

    it "should return all students who know the languages php AND java" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:user, programming_languages: [php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [php], languages: [english])
      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german, english])

      matching_students = User.search_students_by_language_and_programming_language([], ["php", "java"])
      assert_equal(matching_students.length, 2);
    end

  end

  describe"#searchStudent" do
  it "returns an array of students whos description contain a queryed string"do
    expect(User.search_student('Englisch')).to include(@student)
  end
  it "returns an array of students whos description contain a queryed string"do
      expect(User.search_student('Master')).to include(@student)
  end

  it "should return an empty array if anyone speaks the requested language" do
    expect(User.search_student("Hindi")).to eq([])
    end
  end

  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end