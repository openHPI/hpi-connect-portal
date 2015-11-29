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
#  visibility_id          :integer          default(0), not null
#  dschool_status_id      :integer          default(0), not null
#  group_id               :integer          default(0), not null
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

    it "updates linkedin_url" do
      allow(linkedin_client).to receive(:profile).and_return({"public_profile_url" => "http://test.de"})
      student.update_from_linkedin(linkedin_client)
      student.reload.linkedin.should eq("http://test.de")
    end

    it "updates name" do
      allow(linkedin_client).to receive(:profile).and_return({"first-name" => "Bla", "last-name" => "Keks"})
      student.update_from_linkedin(linkedin_client)
      student.reload.full_name.should eq("Bla Keks")
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

  end

  describe "Deliver Newsletter" do
    before(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it "delivers newsletters" do
      search_hash_1 = {state: 1}
      FactoryGirl.create(:newsletter_order, search_params: search_hash_1)
      search_hash_2 = {state: 1}
      FactoryGirl.create(:newsletter_order, search_params: search_hash_2)
      FactoryGirl.create(:job_offer, state_id:1, status: JobStatus.active)
      FactoryGirl.create(:job_offer, state_id:3, status: JobStatus.active)
      Student.deliver_newsletters
      ActionMailer::Base.deliveries.count.should == 2
    end

    it "does not deliver newsletters to students who do not want it" do
      student_without_newsletter_order = FactoryGirl.create(:student)
      search_hash = {state: 4}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 4, status: JobStatus.active)
      Student.deliver_newsletters
      ActionMailer::Base.deliveries.count.should == 2
      ActionMailer::Base.deliveries.each do |mail|
        mail.to.should_not eq([student_without_newsletter_order.email])
      end
    end

    it "delivers newsletter with empty search_hash" do
      search_hash = {}
      newsletter_order = FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, status: JobStatus.active)
      Student.deliver_newsletters
      ActionMailer::Base.deliveries.count.should == 1
      ActionMailer::Base.deliveries.first.to.should eq([newsletter_order.student.email])
    end

    it "does not deliver if search_hash doesn't match" do
      search_hash = {state: 3}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 5, status: JobStatus.active)
      Student.deliver_newsletters
      ActionMailer::Base.deliveries.count.should == 0
    end

    it "does not deliver if Job is too much in the past" do
      search_hash = {state: 3}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 3, status: JobStatus.active, created_at: DateTime.current-Student::NEWSLETTER_DELIVERIES_CYCLE-1)
      Student.deliver_newsletters
      ActionMailer::Base.deliveries.count.should == 0
    end
  end
end
