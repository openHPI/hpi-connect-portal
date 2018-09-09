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
  let(:programming_language) { FactoryBot.create(:programming_language) }
  let(:english_language) { FactoryBot.create(:language, name: 'English') }
  let!(:student) { FactoryBot.create(:student, languages: [english_language], programming_languages: [programming_language]) }

  describe "#visibility" do
    it "returns visibility level in text form" do
      student.update_attributes visibility_id: Student::VISIBILITYS.index('nobody')
      expect(student.visibility).to eq('nobody')
      student.update_attributes visibility_id: Student::VISIBILITYS.index('employers_only')
      expect(student.visibility).to eq('employers_only')
      student.update_attributes visibility_id: Student::VISIBILITYS.index('employers_and_students')
      expect(student.visibility).to eq('employers_and_students')
      student.update_attributes visibility_id: Student::VISIBILITYS.index('students_only')
      expect(student.visibility).to eq('students_only')
    end
  end

  describe ".deliver_newsletters" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    it "delivers newsletters" do
      search_hash_1 = {state: 1}
      FactoryBot.create(:newsletter_order, search_params: search_hash_1)
      search_hash_2 = {state: 1}
      FactoryBot.create(:newsletter_order, search_params: search_hash_2)
      FactoryBot.create(:job_offer, state_id:1, status: JobStatus.active)
      FactoryBot.create(:job_offer, state_id:3, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "does not deliver newsletters to students who do not want it" do
      student_without_newsletter_order = FactoryBot.create(:student)
      search_hash = {state: 4}
      FactoryBot.create(:newsletter_order, search_params: search_hash)
      FactoryBot.create(:newsletter_order, search_params: search_hash)
      FactoryBot.create(:job_offer, state_id: 4, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(2)
      ActionMailer::Base.deliveries.each do |mail|
        expect(mail.to).not_to eq([student_without_newsletter_order.email])
      end
    end

    it "delivers newsletter with empty search_hash" do
      search_hash = {}
      newsletter_order = FactoryBot.create(:newsletter_order, search_params: search_hash)
      FactoryBot.create(:job_offer, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.first.to).to eq([newsletter_order.student.email])
    end

    it "does not deliver if search_hash doesn't match" do
      search_hash = {state: 3}
      FactoryBot.create(:newsletter_order, search_params: search_hash)
      FactoryBot.create(:job_offer, state_id: 5, status: JobStatus.active)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "does not deliver if Job is too much in the past" do
      search_hash = {state: 3}
      FactoryBot.create(:newsletter_order, search_params: search_hash)
      FactoryBot.create(:job_offer, state_id: 3, status: JobStatus.active, created_at: DateTime.current-Student::NEWSLETTER_DELIVERIES_CYCLE-1)
      Student.deliver_newsletters
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  describe "#get_current_enterprises_and_positions" do
    it "should return the current enterprises and positions" do
      current_cv_job1 = FactoryBot.create(:cv_job, current: true)
      current_cv_job2 = FactoryBot.create(:cv_job, current: true, employer: "HPI", position: "Hiwi")
      student.cv_jobs = [current_cv_job1, current_cv_job2]
      expect(student.get_current_enterprises_and_positions).to eq(["SAP AG, HPI", "Ruby on Rails developer, Hiwi"])
    end

    it "should return two empty strings if there are no current positions" do
      expect(student.get_current_enterprises_and_positions).to eq(["", ""])
    end
  end

  describe ".export_alumni" do
    before(:each) do
      require 'csv'

      @registered = FactoryBot.create(:student)
      @registered.user.update_attributes(alumni_email: 'registered.alumni')
      current_cv_job = FactoryBot.create(:cv_job, current: true)
      @registered.cv_jobs = [current_cv_job]

      @pending = FactoryBot.create(:alumni)

      @registered_a_year_ago = FactoryBot.create(:student)
      @registered_a_year_ago.user.update_attributes(alumni_email: 'registered.ayearago', created_at: Date.today - 1.years)
    end

    it "should export all alumni if options are set accordingly" do
      csv = CSV.parse(Student.export_alumni(true, nil, nil))
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s) registered_on})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email + "@hpi-alumni.de", @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer", @registered.created_at.strftime("%d.%m.%Y")])
      expect(csv[2]).to eq(["yes", @registered_a_year_ago.lastname, @registered_a_year_ago.firstname, @registered_a_year_ago.alumni_email + "@hpi-alumni.de", @registered_a_year_ago.email, "General Qualification for University Entrance", "", "", @registered_a_year_ago.created_at.strftime("%d.%m.%Y")])
      expect(csv[3]).to eq([I18n.t('alumni.following_alumni_are_not_registered_yet'), "", "", ""])
      expect(csv[4]).to eq(["no", @pending.lastname, @pending.firstname, @pending.alumni_email + "@hpi-alumni.de", @pending.email])
    end

    it "should not include unregistered alumni if option is not set" do
      csv = CSV.parse(Student.export_alumni(false, nil, nil))
      csv_array = csv.to_a
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s) registered_on})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email + "@hpi-alumni.de", @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer", @registered.created_at.strftime("%d.%m.%Y")])
      expect(csv[2]).to eq(["yes", @registered_a_year_ago.lastname, @registered_a_year_ago.firstname, @registered_a_year_ago.alumni_email + "@hpi-alumni.de", @registered_a_year_ago.email, "General Qualification for University Entrance", "", "", @registered_a_year_ago.created_at.strftime("%d.%m.%Y")])
    end

    it "should not include alumni registered outside of timeframe specified" do
      csv = CSV.parse(Student.export_alumni(false, Date.today - 6.months, Date.today))
      csv_array = csv.to_a
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s) registered_on})
      expect(csv[1]).to eq(["yes", @registered.lastname, @registered.firstname, @registered.alumni_email + "@hpi-alumni.de", @registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer", @registered.created_at.strftime("%d.%m.%Y")])
    end
  end
end
