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

require 'rails_helper'

describe Student do
  before(:each) do
    @english = Language.create(name: 'english')
    @programming_language = FactoryGirl.create(:programming_language)
    @student = FactoryGirl.create(:student, languages: [@english], programming_languages: [@programming_language])
  end

  subject { @student }

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
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "does not deliver newsletters to students who do not want it" do
      student_without_newsletter_order = FactoryGirl.create(:student)
      search_hash = {state: 4}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 4, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(2)
      ActionMailer::Base.deliveries.each do |mail|
        expect(mail.to).not_to eq([student_without_newsletter_order.email])
      end
    end

    it "delivers newsletter with empty search_hash" do
      search_hash = {}
      newsletter_order = FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.first.to).to eq([newsletter_order.student.email])
    end

    it "does not deliver if search_hash doesn't match" do
      search_hash = {state: 3}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 5, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "does not deliver if Job is too much in the past" do
      search_hash = {state: 3}
      FactoryGirl.create(:newsletter_order, search_params: search_hash)
      FactoryGirl.create(:job_offer, state_id: 3, status: JobStatus.active, created_at: DateTime.current-Student::NEWSLETTER_DELIVERIES_CYCLE-1)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  describe "get_current_enterprises_and_positions" do
    it "should return the current enterprises and positions" do
      alumni = FactoryGirl.create(:student)
      current_cv_job1 = FactoryGirl.create(:cv_job, current: true)
      current_cv_job2 = FactoryGirl.create(:cv_job, current: true, employer: "HPI", position: "Hiwi")
      alumni.cv_jobs = [current_cv_job1, current_cv_job2]
      expect(alumni.get_current_enterprises_and_positions).to eq(["SAP AG, HPI", "Ruby on Rails developer, Hiwi"])
    end

    it "should return two empty strings if there are no current positions" do
      alumni = FactoryGirl.create(:student)
      expect(alumni.get_current_enterprises_and_positions).to eq(["", ""])
    end
  end

  describe "export_alumni" do
    before(:each) do
      require 'csv'

      @registered = FactoryGirl.create(:student)
      @registered.user.update_attributes(alumni_email: 'registered.alumni')
      current_cv_job = FactoryGirl.create(:cv_job, current: true)
      @registered.cv_jobs = [current_cv_job]

      @pending = FactoryGirl.create(:alumni)

      @registered_a_year_ago = FactoryGirl.create(:student)
      @registered_a_year_ago.user.update_attributes(alumni_email: 'registered.ayearago', created_at: Date.today - 1.years)
    end

    it "should export all alumni if options are set accordingly" do
      csv = CSV.parse(Student.export_alumni(true, nil, nil))
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s)})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email, @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer"])
      expect(csv[2]).to eq(["yes", @registered_a_year_ago.lastname, @registered_a_year_ago.firstname, @registered_a_year_ago.alumni_email, @registered_a_year_ago.email, "General Qualification for University Entrance", "", ""])
      expect(csv[3]).to eq(["The following alumni are not registered, yet", "", "", ""])
      expect(csv[4]).to eq(["no", @pending.lastname, @pending.firstname, @pending.alumni_email, @pending.email])
    end

    it "should not include unregistered alumni if option is not set" do
      csv = CSV.parse(Student.export_alumni(false, nil, nil))
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s)})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email, @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer"])
      expect(csv[2]).to eq(["yes", @registered_a_year_ago.lastname, @registered_a_year_ago.firstname, @registered_a_year_ago.alumni_email, @registered_a_year_ago.email, "General Qualification for University Entrance", "", ""])
    end

    it "should not include alumni registered outside of timeframe specified" do
      csv = CSV.parse(Student.export_alumni(false, Date.today - 6.months, Date.today))
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s)})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email, @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer"])
    end
  end
end
