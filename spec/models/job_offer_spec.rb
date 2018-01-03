# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

require 'rails_helper'

describe JobOffer do

  before(:each) do
      @epic = FactoryBot.create(:employer, name: "EPIC")
      @os = FactoryBot.create(:employer, name: "OS and Middleware")
      @itas = FactoryBot.create(:employer, name: "Internet and Systems Technologies")
  end

  it "does not create a joboffer if attributes are not set" do
    assert !JobOffer.create.valid?
  end

  it "does create a joboffer if all required attributes are set and valid" do
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: @epic,
      start_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
  end

  it "does not create a joboffer if start_date is after end_date" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website",
      employer: @epic, start_date: Date.current + 2, end_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
  end

  it "does create a joboffer if end_date is after start_date" do
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: @epic,
      start_date: Date.current + 1, end_date: Date.current + 2, compensation: 10.5, time_effort: 9).valid?
  end

  it "does not create a joboffer if compensation is not a number" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: @epic,
      start_date: Date.current + 1, compensation: "i gonna be rich", time_effort: 9).valid?
  end

  it "returns job offers sorted by created_at" do

    FactoryBot.create(:job_offer, start_date: Date.current + 2, end_date: Date.current + 3, created_at: Date.current + 2, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 10, end_date: Date.current + 11, created_at: Date.current + 10, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 1, end_date: Date.current + 2, created_at: Date.current + 1, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 7, end_date: Date.current + 8, created_at: Date.current + 7, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 4, end_date: Date.current + 5, created_at: Date.current + 4, employer: @epic)

    sorted_job_offers = JobOffer.sort(JobOffer.all, "date")
    (sorted_job_offers).each_with_index do |offer, index|

       if !sorted_job_offers.length == (index + 1)
        expect(offer.expiration_date).to be >= sorted_job_offers[index+1].expiration_date
       end
    end
  end

  it "returns job offers sorted by their employer" do

    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @itas)
    FactoryBot.create(:job_offer, employer: @os)

    sorted_job_offers = JobOffer.sort(JobOffer.all, "employer")
    (sorted_job_offers).each_with_index do |offer, index|

       if sorted_job_offers.length == (index + 1)
        break
       end
      expect(offer.employer.name).to be <= sorted_job_offers[index+1].employer.name
    end
  end

  it "returns job offers including the word EPIC" do

    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @itas, description: "develop a website with an epic framework")
    FactoryBot.create(:job_offer, employer: @itas)
    FactoryBot.create(:job_offer, employer: @os)

    resulted_job_offers = JobOffer.search("EPIC")
    assert_equal(resulted_job_offers.length, 3);
  end

  it "returns job offers filtered by employer EPIC and start_date >= specified_date" do

    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 6, end_date: Date.current + 8)
    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 1, end_date: Date.current + 8)
    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 5, end_date: Date.current + 8)
    FactoryBot.create(:job_offer, employer: @itas)
    FactoryBot.create(:job_offer, employer: @os)

    filtered_job_offers = JobOffer.filter_employer(@epic.id).filter_start_date((Date.current + 3).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered start_date >= specified_date" do

    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 6, end_date: Date.current + 8)
    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 1, end_date: Date.current + 8)
    FactoryBot.create(:job_offer, employer: @epic, start_date: Date.current + 5, end_date: Date.current + 8)

    filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered by employer EPIC" do

    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @epic)
    FactoryBot.create(:job_offer, employer: @itas)
    FactoryBot.create(:job_offer, employer: @os)

    filtered_job_offers = JobOffer.filter_employer(@epic.id)
    assert_equal(filtered_job_offers.length, 3);
  end

  it "returns job offers filtered between start_date and end_date" do

    FactoryBot.create(:job_offer, start_date: Date.current + 6, end_date: Date.current + 8, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 1, end_date: Date.current + 8, employer: @epic)
    FactoryBot.create(:job_offer, start_date: Date.current + 5, end_date: Date.current + 8, employer: @epic)

    filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d")).filter_end_date((Date.current + 9).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered with compensation>=10 AND time_effort<=5" do

    FactoryBot.create(:job_offer, time_effort: 10, compensation: 20, employer: @epic)
    FactoryBot.create(:job_offer, time_effort: 5, compensation: 20, employer: @epic)
    FactoryBot.create(:job_offer, time_effort: 8, compensation: 5, employer: @epic)
    FactoryBot.create(:job_offer, time_effort: 4, compensation: 8, employer: @epic)

    filtered_job_offers = JobOffer.filter_compensation(10).filter_time_effort(5)
    assert_equal(filtered_job_offers.length, 1);
  end

  it "returns job offers searched for programming languages filtered by time effort and sorted by employer" do

    FactoryBot.create(:job_offer, time_effort: 10, employer: @epic, description: "Ruby Programming")
    job_offer_itas = FactoryBot.create(:job_offer, time_effort: 8, employer: @itas, description: "Ruby Programming")
    FactoryBot.create(:job_offer, time_effort: 5, employer: @epic, description: "Javascript Programming")
    job_offer_os = FactoryBot.create(:job_offer, time_effort: 4, employer: @os, description: "Ruby Programming")

    filtered_job_offers = JobOffer.search("Ruby").filter_time_effort(8)
    assert_equal(filtered_job_offers.length, 2);
    assert filtered_job_offers.include?(job_offer_itas)
    assert filtered_job_offers.include?(job_offer_os)
  end

  it "return job offers which only have the specified programming languages" do
    offer_matched = FactoryBot.create(:job_offer, time_effort: 10, employer: @epic, description: "Ruby Programming")
    offer_not_matched = FactoryBot.create(:job_offer, time_effort: 10, employer: @epic, description: "Python Programming")

    language_one = FactoryBot.create(:programming_language, job_offer: [offer_matched])
    language_two = FactoryBot.create(:programming_language, job_offer: [offer_matched])
    language_three = FactoryBot.create(:programming_language, job_offer: [offer_not_matched])

    filtered_jobs = JobOffer.filter_programming_languages([language_one.id, language_two.id])
    assert_equal(filtered_jobs.length, 1)

    filtered_jobs = JobOffer.filter_programming_languages([language_one.id, language_two.id, language_three.id])
    assert_equal(filtered_jobs.length, 2)

    filtered_jobs = JobOffer.filter_programming_languages([])
    assert_equal(filtered_jobs.length, 0)
  end

  it "return job offers which only have the specified programming languages" do
    offer_matched = FactoryBot.create(:job_offer, time_effort: 10, employer: @epic, description: "Ruby Programming")
    offer_not_matched = FactoryBot.create(:job_offer, time_effort: 10, employer: @epic, description: "Python Programming")

    language_one = FactoryBot.create(:language)
    language_two = FactoryBot.create(:language)
    language_three = FactoryBot.create(:language)

    offer_matched.languages = [language_one, language_two]
    offer_matched.save

    offer_not_matched.languages = [language_three]
    offer_not_matched.save

    filtered_jobs = JobOffer.filter_languages([language_one.id, language_two.id])
    assert_equal(filtered_jobs.length, 1)

    filtered_jobs = JobOffer.filter_languages([language_one.id, language_two.id, language_three.id])
    assert_equal(filtered_jobs.length, 2)

    filtered_jobs = JobOffer.filter_languages([])
    assert_equal(filtered_jobs.length, 0)
  end

  it "returns job offers filtered by status" do
    @status = FactoryBot.create(:job_status, name: "closed")
    job_offer_with_status = FactoryBot.create(:job_offer, status: @status)
    FactoryBot.create(:job_offer, employer: @epic)
    filtered_job_offers = JobOffer.where(status: @status)
    assert filtered_job_offers.include? job_offer_with_status
    assert_equal(filtered_job_offers.length, 1)
  end

  describe 'expiration' do

    before :each do
      JobOffer.delete_all
      @job_offer_valid = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.active)
      ActionMailer::Base.deliveries = []
    end

    it "sends an email 2 days before expiration" do
      @job_offer_warning = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.active, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      JobOffer.check_for_expired
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @epic.staff_members.collect(&:email))
    end

    it "sends an email on expiration and closes the job offer" do
      @job_offer_expire = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.active, prolonged: true, prolonged_at: Date.today - 8.weeks)
      JobOffer.check_for_expired
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @epic.staff_members.collect(&:email))
      assert_equal(@job_offer_expire.reload.status, JobStatus.closed)
    end

    it "does only send emails with active status" do
      @job_offer_warning = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.closed, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      @job_offer_warning = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.pending, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      @job_offer_expire = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.closed, prolonged: true, prolonged_at: Date.today - 8.weeks)
      @job_offer_expire = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.pending, prolonged: true, prolonged_at: Date.today - 8.weeks)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "should set the job status back to active after prolognation" do
      @job_expired = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.closed)
      @job_expired.prolong
      assert_equal(@job_expired.reload.prolonged, true)
      assert_equal(@job_expired.reload.status, JobStatus.active)
    end
  end
end
