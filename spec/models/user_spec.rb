# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  identity_url           :string(255)
#  lastname               :string(255)
#  firstname              :string(255)
#  role_id                :integer          default(1), not null
#  chair_id               :integer
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
#  photo_file_name        :date
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :date
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :date
#  status                 :integer
#  user_status_id         :integer
#


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
#  status                 :integer
#  student_status_id      :integer
#

require 'spec_helper'

describe User do
  before(:each) do
    @english = Language.create(:name=>'english')
    @user = FactoryGirl.create(:user)
    @student = FactoryGirl.create(:user, :languages=>[@english],
      :programming_languages=>[ProgrammingLanguage.create(:name=>'Ruby')])
  end

  subject { @user }

  describe 'applying' do
    before do
      @job_offer = FactoryGirl.create(:job_offer)
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
      expect(User.search_students_by_language_identifier(:programming_languages, 'Ruby')).to include @student
    end

    it "should return an empty array if anyone speaks the requested language" do
      expect(User.search_students_by_language_identifier(:programming_languages, "Hindi")).to eq([])
    end
  end

  describe"#searchStudentsByLanguage" do
    it "returns an array of students who speak a language" do
      expect(User.search_students_by_language_identifier(:languages, 'English')).to include(@student)
    end

    it "should return an empty array if anyone speaks the requested language" do
      expect(User.search_students_by_language_identifier(:languages, "Hindi")).to eq([])
    end
  end

  describe"#search_students_by_language_and_programming_language" do

    before do
      @java = FactoryGirl.create(:programming_language, name: "Java")
      @php = FactoryGirl.create(:programming_language, name: "PHP")
      @german = FactoryGirl.create(:language, name: "German")
      @english = FactoryGirl.create(:language, name: "English")

      FactoryGirl.create(:user, programming_languages: [@java, @php], languages: [@german])
      FactoryGirl.create(:user, programming_languages: [@java], languages: [@german, @english])
      FactoryGirl.create(:user, programming_languages: [@php], languages: [@german])
      FactoryGirl.create(:user, programming_languages: [@php], languages: [@english])
      FactoryGirl.create(:user, programming_languages: [@java, @php], languages: [@german, @english])
    end

    it "should return all students who speak the language german AND know the programming language php" do
      matching_students = User.search_students_by_language_and_programming_language(["german"], ["php"])
      assert_equal(matching_students.length, 3);
    end

    it "should return all students who speak the language german AND" do
      matching_students = User.search_students_by_language_and_programming_language(["german"], [])
      assert_equal(matching_students.length, 4);
    end

    it "should return all students who know the languages php AND java" do
      matching_students = User.search_students_by_language_and_programming_language([], ["php", "java"])
      assert_equal(matching_students.length, 2);
    end

    it "returns no students for Python" do
      matching_students = User.search_students_by_language_and_programming_language([], ["Python"])
      assert_equal(matching_students.length, 0);
    end

  end

  describe"#searchStudent" do
  it "returns an array of students whos description contain a queryed string"do
    expect(User.search_student('english')).to include(@student)
  end
  it "returns an array of students whos description contain a queryed string"do
      expect(User.search_student('Master')).to include(@student)
  end

  it "should return an empty array if anyone speaks the requested language" do
    expect(User.search_student("Hindi")).to eq([])
    end
  end

  describe "#change birthdate" do
		it "should accept valid birthdate" do
			FactoryGirl.build(:user, birthday: "05-06-1986").should be_valid
		end

		it "should not accept 30th of february" do
			FactoryGirl.build(:user, birthday: "30-02-1986").birthday.should be_nil
		end

		it "should not accept 31th june" do
			FactoryGirl.build(:user, birthday: "31-06-1986").birthday.should be_nil
		end
	end


  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end
