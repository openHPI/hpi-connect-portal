# == Schema Information
#
# Table name: students
#
#  id                        :integer          not null, primary key
#  semester                  :integer
#  academic_program          :string(255)
#  education                 :text
#  additional_information    :text
#  birthday                  :date
#  homepage                  :string(255)
#  github                    :string(255)
#  facebook                  :string(255)
#  xing                      :string(255)
#  linkedin                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  employment_status_id      :integer          default(0), not null
#  frequency                 :integer          default(1), not null
#  academic_program_id       :integer          default(0), not null
#  graduation_id             :integer          default(0), not null
#  visibility_id             :integer          default(0), not null
#  dschool_status_id         :integer          default(0), not null
#  group_id                  :integer          default(0), not null
#  hidden_title              :string(255)
#  hidden_birth_name         :string(255)
#  hidden_graduation_id      :integer
#  hidden_graduation_year    :integer
#  hidden_private_email      :string(255)
#  hidden_alumni_email       :string(255)
#  hidden_additional_email   :string(255)
#  hidden_last_employer      :string(255)
#  hidden_current_position   :string(255)
#  hidden_street             :string(255)
#  hidden_location           :string(255)
#  hidden_postcode           :string(255)
#  hidden_country            :string(255)
#  hidden_phone_number       :string(255)
#  hidden_comment            :string(255)
#  hidden_agreed_alumni_work :boolean
#

require 'spec_helper'

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
end
