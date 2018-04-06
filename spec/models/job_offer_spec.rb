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
  let(:employer) { FactoryBot.create(:employer) }

  describe "validations" do
    it "does not create a joboffer if attributes are not set" do
      assert !JobOffer.create.valid?
    end

    it "does create a joboffer if all required attributes are set and valid" do
      assert JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: employer,
        start_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
    end

    it "does not create a joboffer if start_date is after end_date" do
      assert !JobOffer.create(title:"Awesome Job", description: "Develope a website",
        employer: @epic, start_date: Date.current + 2, end_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
    end

    it "does create a joboffer if end_date is after start_date" do
      assert JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: employer,
        start_date: Date.current + 1, end_date: Date.current + 2, compensation: 10.5, time_effort: 9).valid?
    end

    it "does not create a joboffer if compensation is not a number" do
      assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", employer: employer,
        start_date: Date.current + 1, compensation: "i gonna be rich", time_effort: 9).valid?
    end
  end

  describe ".sort" do
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
  end

  describe "scopes" do
    let(:epic_employer) { FactoryBot.create(:employer, name: 'Epic Employer') }

    it "returns job offers including a word" do
      FactoryBot.create(:job_offer, employer: epic_employer)
      FactoryBot.create(:job_offer, employer: epic_employer)
      FactoryBot.create(:job_offer, description: "develop a website with an epic framework")
      FactoryBot.create(:job_offer)
      FactoryBot.create(:job_offer)

      resulted_job_offers = JobOffer.search("epic")
      expect(resulted_job_offers.length).to eq(3)
    end

    context "filtering by student group" do
      let!(:hpi_job_offer) { FactoryBot.create(:job_offer, student_group_id: Student::GROUPS.index('hpi')) }
      let!(:dschool_job_offer) { FactoryBot.create(:job_offer, student_group_id: Student::GROUPS.index('dschool')) }
      let!(:job_offer_for_both) { FactoryBot.create(:job_offer, student_group_id: Student::GROUPS.index('both')) }

      it "returns job offers for HPI students" do
        filtered_job_offers = JobOffer.filter_student_group(Student::GROUPS.index('hpi').to_s)
        expect(filtered_job_offers).to include(hpi_job_offer)
        expect(filtered_job_offers).to include(job_offer_for_both)
        expect(filtered_job_offers).not_to include(dschool_job_offer)
      end

      it "returns job offers for D-School students" do
        filtered_job_offers = JobOffer.filter_student_group(Student::GROUPS.index('dschool').to_s)
        expect(filtered_job_offers).not_to include(hpi_job_offer)
        expect(filtered_job_offers).to include(job_offer_for_both)
        expect(filtered_job_offers).to include(dschool_job_offer)
      end
    end

    it "returns job offers filtered start_date >= specified_date" do
      FactoryBot.create(:job_offer, start_date: Date.current + 6, end_date: Date.current + 8)
      FactoryBot.create(:job_offer, start_date: Date.current + 1, end_date: Date.current + 8)
      FactoryBot.create(:job_offer, start_date: Date.current + 5, end_date: Date.current + 8)

      filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d"))
      assert_equal(filtered_job_offers.length, 2);
    end

    it "returns job offers filtered by employer" do
      FactoryBot.create(:job_offer, employer: employer)
      FactoryBot.create(:job_offer, employer: employer)
      FactoryBot.create(:job_offer, employer: employer)
      FactoryBot.create(:job_offer)
      FactoryBot.create(:job_offer)

      filtered_job_offers = JobOffer.filter_employer(employer.id)
      assert_equal(filtered_job_offers.length, 3);
    end

    it "returns job offers filtered between start_date and end_date" do
      FactoryBot.create(:job_offer, start_date: Date.current + 6, end_date: Date.current + 8)
      FactoryBot.create(:job_offer, start_date: Date.current + 1, end_date: Date.current + 8)
      FactoryBot.create(:job_offer, start_date: Date.current + 5, end_date: Date.current + 8)

      filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d")).filter_end_date((Date.current + 9).strftime("%Y%m%d"))
      assert_equal(filtered_job_offers.length, 2);
    end

    it "returns job offers filtered with compensation>=10 AND time_effort<=5" do
      FactoryBot.create(:job_offer, time_effort: 10, compensation: 20)
      FactoryBot.create(:job_offer, time_effort: 5, compensation: 20)
      FactoryBot.create(:job_offer, time_effort: 8, compensation: 5)
      FactoryBot.create(:job_offer, time_effort: 4, compensation: 8)

      filtered_job_offers = JobOffer.filter_compensation(10).filter_time_effort(5)
      assert_equal(filtered_job_offers.length, 1);
    end

    it "return job offers which only have the specified programming languages" do
      offer_matched = FactoryBot.create(:job_offer, time_effort: 10, description: "Ruby Programming")
      offer_not_matched = FactoryBot.create(:job_offer, time_effort: 10, description: "Python Programming")

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
      job_offer_with_status = FactoryBot.create(:job_offer, status: JobStatus.closed)
      FactoryBot.create(:job_offer)
      filtered_job_offers = JobOffer.where(status: JobStatus.closed)
      assert filtered_job_offers.include? job_offer_with_status
      assert_equal(filtered_job_offers.length, 1)
    end
  end

  describe ".apply_saved_scopes" do

    it "filters by state" do
      job_offer_in_state = FactoryBot.create(:job_offer, state_id: JobOffer::STATES.index('BB'))
      job_offer_out_of_state = FactoryBot.create(:job_offer, state_id: JobOffer::STATES.index('MV'))
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { state: JobOffer::STATES.index('BB') })
      expect(returned_job_offers).to include(job_offer_in_state)
      expect(returned_job_offers).not_to include(job_offer_out_of_state)
    end

    it "filters by employer" do
      cool_employer = FactoryBot.create(:employer, name: 'Really Cool Company')
      cool_job_offer = FactoryBot.create(:job_offer, employer: cool_employer)
      regular_job_offer = FactoryBot.create(:job_offer)
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { employer: cool_employer.id })
      expect(returned_job_offers).to include(cool_job_offer)
      expect(returned_job_offers).not_to include(regular_job_offer)
    end

    it "filters by category" do
      big_job = FactoryBot.create(:job_offer, category_id: JobOffer::CATEGORIES.index('graduate_job'))
      small_job = FactoryBot.create(:job_offer, category_id: JobOffer::CATEGORIES.index('working_student'))
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { category: JobOffer::CATEGORIES.index('graduate_job') })
      expect(returned_job_offers).to include(big_job)
      expect(returned_job_offers).not_to include(small_job)
    end

    it "filters by graduations" do
      easy_job = FactoryBot.create(:job_offer, graduation_id: Student::GRADUATIONS.index('abitur'))
      hard_job = FactoryBot.create(:job_offer, graduation_id: Student::GRADUATIONS.index('phd'))
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { graduations: Student::GRADUATIONS.index('abitur') })
      expect(returned_job_offers).to include(easy_job)
      expect(returned_job_offers).not_to include(hard_job)
    end

    it "filters by start and end date" do
      short_time_job = FactoryBot.create(:job_offer, start_date: Date.current, end_date: Date.current + 6.month)
      long_time_job = FactoryBot.create(:job_offer, start_date: Date.current + 2.month, end_date: Date.current + 2.year)
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { start_date: (Date.current + 1.month).to_s, end_date: (Date.current + 3.year).to_s })
      expect(returned_job_offers).to include(long_time_job)
      expect(returned_job_offers).not_to include(short_time_job)
    end

    it "filters by time expenditure" do
      part_time_job = FactoryBot.create(:job_offer, time_effort: 5)
      full_time_job = FactoryBot.create(:job_offer, time_effort: 40)
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { time_effort: 10 })
      expect(returned_job_offers).to include(part_time_job)
      expect(returned_job_offers).not_to include(full_time_job)
    end

    it "filters by compensation" do
      illegal_job = FactoryBot.create(:job_offer, compensation: 5)
      legal_job = FactoryBot.create(:job_offer, compensation: 15)
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { compensation: 10 })
      expect(returned_job_offers).to include(legal_job)
      expect(returned_job_offers).not_to include(illegal_job)
    end

    let(:korean_language) { FactoryBot.create(:language, name: 'Korean') }
    let(:english_language) { FactoryBot.create(:language, name: 'English') }

    it "filters by languages" do
      foreign_job = FactoryBot.create(:job_offer, languages: [korean_language])
      english_job = FactoryBot.create(:job_offer, languages: [english_language])
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { language_ids: [korean_language.id] })
      expect(returned_job_offers).to include(foreign_job)
      expect(returned_job_offers).not_to include(english_job)
    end

    let(:java) { FactoryBot.create(:programming_language, name: 'Java') }
    let(:ruby) { FactoryBot.create(:programming_language, name: 'Ruby') }

    it "filters by programming languages" do
      java_job = FactoryBot.create(:job_offer, programming_languages: [java])
      ruby_job = FactoryBot.create(:job_offer, programming_languages: [ruby])
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { programming_language_ids: [java.id] })
      expect(returned_job_offers).to include(java_job)
      expect(returned_job_offers).not_to include(ruby_job)
    end

    it "filters by student groups" do
      dschool_job = FactoryBot.create(:job_offer, student_group_id: Student::GROUPS.index('dschool'))
      hpi_job = FactoryBot.create(:job_offer, student_group_id: Student::GROUPS.index('hpi'))
      returned_job_offers = JobOffer.apply_saved_scopes(JobOffer.active, { student_group: Student::GROUPS.index('hpi').to_s })
      expect(returned_job_offers).to include(hpi_job)
      expect(returned_job_offers).not_to include(dschool_job)
    end
  end

  describe '.check_for_expired' do
    before(:each) do
      @job_offer_valid = FactoryBot.create(:job_offer, employer: @epic, status: JobStatus.active)
      ActionMailer::Base.deliveries = []
    end

    it "sends an email 2 days before expiration" do
      @job_offer_warning = FactoryBot.create(:job_offer, status: JobStatus.active, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      JobOffer.check_for_expired
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @job_offer_warning.employer.staff_members.collect(&:email))
    end

    it "sends an email on expiration and closes the job offer" do
      @job_offer_expire = FactoryBot.create(:job_offer, status: JobStatus.active, prolonged: true, prolonged_at: Date.today - 8.weeks)
      JobOffer.check_for_expired
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @job_offer_expire.employer.staff_members.collect(&:email))
      assert_equal(@job_offer_expire.reload.status, JobStatus.closed)
    end

    it "does only send emails with active status" do
      @job_offer_warning = FactoryBot.create(:job_offer, status: JobStatus.closed, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      @job_offer_warning = FactoryBot.create(:job_offer, status: JobStatus.pending, prolonged: true, prolonged_at: Date.today - 8.weeks + 2.days)
      @job_offer_expire = FactoryBot.create(:job_offer, status: JobStatus.closed, prolonged: true, prolonged_at: Date.today - 8.weeks)
      @job_offer_expire = FactoryBot.create(:job_offer, status: JobStatus.pending, prolonged: true, prolonged_at: Date.today - 8.weeks)
      JobOffer.check_for_expired
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  describe "#prolong" do
    let!(:expired_job_offer) { FactoryBot.create(:job_offer, status: JobStatus.closed, employer: employer) }

    it "sets the job status back to active" do
      expired_job_offer.prolong
      assert_equal(expired_job_offer.status, JobStatus.active)
    end

    it "marks the job offer as prolonged" do
      expired_job_offer.prolong
      assert_equal(expired_job_offer.reload.prolonged, true)
    end

    it "sends a mail to all relevant staff members" do
      expect {
        expired_job_offer.prolong
      }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq(expired_job_offer.employer.staff_members.collect(&:email))
      expect(email.subject).to eq(I18n.t('job_offers_mailer.job_offer_prolonged.subject'))
    end
  end
end
