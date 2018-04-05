# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description_de            :text
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
#  description_en            :text
#

class JobOffer < ActiveRecord::Base
  include JobOfferScopes

  CATEGORIES = ['traineeship', 'sideline', 'graduate_job', 'working_student', 'teammate']
  STATES = ['ABROAD', 'BW', 'BY', 'BE', 'BB', 'HB', 'HH', 'HE', 'MV', 'NI', 'NW', 'RP', 'SL', 'SN', 'ST', 'SH', 'TH']

  has_attached_file :offer_as_pdf

  before_save :default_values

  has_one :contact, as: :counterpart, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :ratings, dependent: :nullify
  has_and_belongs_to_many :programming_languages
  has_and_belongs_to_many :languages
  belongs_to :employer
  belongs_to :status, class_name: "JobStatus"

  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :contact

  validates_attachment_content_type :offer_as_pdf, content_type: ['application/pdf']

  validates :title, :employer, :category, :state, :graduation_id, :start_date, presence: true
  validates :compensation, :time_effort, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates_datetime :end_date, on_or_after: :start_date, allow_blank: :end_date

  translates :description, fallback: :any

  validate :at_least_one_description

  self.per_page = 15

  def at_least_one_description
    errors.add(:description, I18n.t("errors.messages.blank")) if description_de.blank? and description_en.blank?
  end

  def self.create_and_notify(parameters, current_user)
    job_offer = JobOffer.new parameters, status: JobStatus.pending
    job_offer.employer = current_user.manifestation.employer unless parameters[:employer_id]

    if(job_offer.employer && !job_offer.employer.can_create_job_offer?(job_offer.category))
      job_offer.employer.add_one_single_booked_job
    end

    if job_offer.save && !job_offer.employer.can_create_job_offer?(job_offer.category)
      JobOffersMailer.new_single_job_offer_email(job_offer, job_offer.employer).deliver_now
    elsif job_offer.save && job_offer.employer.can_create_job_offer?(job_offer.category)
      JobOffersMailer.new_job_offer_email(job_offer).deliver_now
    end

    return job_offer
  end

  def self.sort(job_offers, order_attribute)
    if order_attribute == "employer"
      job_offers.sort_by {|job_offer| job_offer.employer.name.downcase}
    else
      job_offers.sort_by {|job_offer| [job_offer.expiration_date, job_offer.created_at] }.reverse
    end
  end

  def self.check_for_expired
    active.each do |offer|
      if offer.expiration_date == Date.today + 2.days
        JobOffersMailer.job_will_expire_email(offer).deliver_now
      elsif offer.expiration_date <= Date.today
        offer.update_column :status_id, JobStatus.closed.id
        JobOffersMailer.job_expired_email(offer).deliver_now
      end
    end
  end

  def self.export_active_jobs
    active_jobs = self.active

    csv_string = ""
    header = "\"#{human_attribute_name(:title)}\";\"#{human_attribute_name(:employer)}\";\"#{human_attribute_name(:category)}\";\"#{human_attribute_name(:release_date)}\"\n"

    csv_string << header

    active_jobs.each do |job|
      row = "\"#{job.title}\";\"#{job.employer.name}\";\"#{job.category}\";\"#{job.release_date}\"\n"
      csv_string << row
    end

    return csv_string
  end

  def default_values
    self.status ||= JobStatus.pending
  end

  def closed?
    status && status == JobStatus.closed
  end

  def pending?
    status && status == JobStatus.pending
  end

  def active?
    status && status == JobStatus.active
  end

  def editable?
    self.pending? || self.active?
  end

  def human_readable_compensation
    (self.compensation == 10.0) ? I18n.t('job_offers.default_compensation') : self.compensation.to_s + " " + I18n.t("job_offers.compensation_description")
  end

  def prolong
    update_column :prolonged_at, Date.current
    update_column :prolonged, true
    update_column :prolong_requested, false
    update_column :status_id, JobStatus.active.id
    JobOffersMailer.job_prolonged_email(self).deliver_now
  end

  def expiration_date
    (prolonged_at || created_at).to_date + 8.weeks
  end

  def category
    CATEGORIES[category_id]
  end

  def state
    STATES[state_id]
  end

  def minimum_degree
    Student::GRADUATIONS[graduation_id]
  end
end
