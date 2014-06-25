# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#

require 'spec_helper'

describe Student do
  before(:each) do
    @english = Language.create(name: 'english')
    @programming_language = FactoryGirl.create(:programming_language)
    @student = FactoryGirl.create(:student, languages: [@english], programming_languages: [@programming_language])
  end

  subject { @student }

  describe 'applying' do
    before do
      @job_offer = FactoryGirl.create(:job_offer)
      @application = Application.create(student: @student, job_offer: @job_offer)
    end

    it { should be_applied(@job_offer) }
    its(:applications) { should include(@application) }
    its(:job_offers) { should include(@job_offer) }
  end

  describe 'update_from_linkedin' do
    let(:linkedin_client) {Student.create_linkedin_client}
    let(:student) {FactoryGirl.create(:student)}

    it "updates birthday" do
      allow(linkedin_client).to receive(:profile).and_return({"date-of-birth" => Date.new(2001,2,3)})
      student.update_from_linkedin(linkedin_client)
      student.reload.birthday.should eq(Date.new(2001,2,3))
    end

    it "updates linkedin_url" do
      allow(linkedin_client).to receive(:profile).and_return({"public_profile_url" => "http://test.de"})
      student.update_from_linkedin(linkedin_client)
      student.reload.linkedin.should eq("http://test.de")
    end

    it "doesn't update employment status if not jobseeking" do
      student = FactoryGirl.create(:student, employment_status_id: Student::EMPLOYMENT_STATUSES.index("employed"))
      allow(linkedin_client).to receive(:profile).and_return({"three_current_positions" => "bla"})
      student.update_from_linkedin(linkedin_client)
      student.reload.employment_status.should eq("employed")
    end

    it "updates employment_status if jobseeking" do
      student = FactoryGirl.create(:student, employment_status_id: Student::EMPLOYMENT_STATUSES.index("jobseeking"))
      allow(linkedin_client).to receive(:profile).and_return({"three-current-positions" => "bla"})
      student.update_from_linkedin(linkedin_client)
      student.reload.employment_status.should eq("employedseeking")
    end

    it "does not update if value is nil" do 
      student = FactoryGirl.create(:student, birthday: Date.new(1991,2,24), linkedin: "testlink")
      allow(linkedin_client).to receive(:profile).and_return({})
      student.update_from_linkedin(linkedin_client)
      student.reload.birthday.should eq(Date.new(1991,2,24))
      student.reload.linkedin.should eq("testlink")
    end

    it "updates name" do
      allow(linkedin_client).to receive(:profile).and_return({"first-name" => "Bla", "last-name" => "Keks"})
      student.update_from_linkedin(linkedin_client)
      student.reload.full_name.should eq("Bla Keks")
    end

    it "updates email" do
      allow(linkedin_client).to receive(:profile).and_return({"email-address" => "bla@keks.de"})
      student.update_from_linkedin(linkedin_client)
      student.reload.user.email.should eq("bla@keks.de")
    end

    it "updates programming languages" do
      FactoryGirl.create(:programming_language, name: "C++")
      FactoryGirl.create(:programming_language, name: "C")
      allow(linkedin_client).to receive(:profile).and_return({"skills" => {"all" => [{"id"=> 3, "skill" => {"name" => "C++"}}, 
                                                                                     {"id"=> 4, "skill" => {"name" => "C"}}, 
                                                                                      {"id"=> 30, "skill" => {"name" => "Rotkohl"}}
                                                                                      ]}})
      student.update_from_linkedin(linkedin_client)
      ProgrammingLanguagesUser.find_by_student_id_and_programming_language_id(student.id, ProgrammingLanguage.find_by_name("C++").id).should_not eq nil
      ProgrammingLanguagesUser.find_by_student_id_and_programming_language_id(student.id, ProgrammingLanguage.find_by_name("C++").id).skill.should eq 3
      ProgrammingLanguagesUser.find_by_student_id_and_programming_language_id(student.id, ProgrammingLanguage.find_by_name("C").id).should_not eq nil
      ProgrammingLanguagesUser.find_by_student_id_and_programming_language_id(student.id, ProgrammingLanguage.find_by_name("C").id).skill.should eq 3
    end

    it "updates minimum possible CV job" do
      allow(linkedin_client).to receive(:profile).and_return(
        {"positions" => 
          {"all" => 
            [{"summary" => "", 
            "is_current" => "true", 
            "company" => {"name" => "HPI"}, 
            "title" => "junior researcher", 
            "start_date" => {"year" => Date.today.year.to_s, "month" => Date.today.month.to_s},
            "end_date" => {"year" => (Date.today.year+ 1).to_s, "month" => Date.today.month.to_s}
            }]
          }
        })
      student.update_from_linkedin(linkedin_client)
      student.reload.cv_jobs[0].student.should eq(student)
      student.reload.cv_jobs[0].employer.should eq("HPI")
      student.reload.cv_jobs[0].position.should eq("junior researcher")
      student.reload.cv_jobs[0].description.should eq("")
      student.reload.cv_jobs[0].start_date.should eq(Date.new(DateTime.now.year, DateTime.now.month))
      student.reload.cv_jobs[0].end_date.should eq(Date.new(Date.today.year+ 1, Date.today.month))
      student.reload.cv_jobs[0].current.should eq(true)
      student.reload.cv_jobs.length.should eq(1)
    end

    it "updates minimum possible CV education" do
      allow(linkedin_client).to receive(:profile).and_return(
        {"educations" => {"all" => [{"school-name" => "HPI"}]}})
      student.update_from_linkedin(linkedin_client)
      student.reload.cv_educations[0].student.should eq(student)
      student.reload.cv_educations[0].degree.should eq("No degree given")
      student.reload.cv_educations[0].field.should eq("No field-of-study given")
      student.reload.cv_educations[0].institution.should eq("HPI")
      student.reload.cv_educations[0].start_date.should eq(Date.new(Time.now.year, Time.now.month))
      student.reload.cv_educations[0].end_date.should eq(Date.new(Time.now.year, Time.now.month))
      student.reload.cv_educations[0].current.should eq(false)
      student.reload.cv_educations.length.should eq(1)
    end
  end
end