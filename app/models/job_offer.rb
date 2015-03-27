# == Schema Information
#
# Table name: job_offers
#
#  id                  :integer          not null, primary key
#  description         :text
#  title               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  time_effort         :float
#  compensation        :float
#  employer_id         :integer
#  status_id           :integer
#  flexible_start_date :boolean          default(FALSE)
#  category_id         :integer          default(0), not null
#  state_id            :integer          default(3), not null
#  graduation_id       :integer          default(2), not null
#  prolong_requested   :boolean          default(FALSE)
#  prolonged           :boolean          default(FALSE)
#  prolonged_at        :datetime
#

class JobOffer < ActiveRecord::Base
  include JobOfferScopes

  CATEGORIES = ['traineeship', 'sideline', 'graduate_job', 'working_student', 'teammate']
  STATES = ['ABROAD', 'BW', 'BY', 'BE', 'BB', 'HB', 'HH', 'HE', 'MV', 'NI', 'NW', 'RP', 'SL', 'SN', 'ST', 'SH', 'TH']
  
  has_attached_file :offer_as_pdf

  before_save :default_values

  has_one :contact, as: :counterpart, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :students, through: :applications
  has_many :assignments, dependent: :destroy
  has_many :assigned_students, through: :assignments, source: :student
  has_and_belongs_to_many :programming_languages
  has_and_belongs_to_many :languages
  belongs_to :employer
  belongs_to :status, class_name: "JobStatus"

  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :contact

  validates_attachment_content_type :offer_as_pdf, content_type: ['application/pdf']


  validates :title, :description, :employer, :category, :state, :graduation_id, :start_date, presence: true
  validates :compensation, :time_effort, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates_datetime :end_date, on_or_after: :start_date, allow_blank: :end_date

  self.per_page = 15

  def self.create_and_notify(parameters, current_user)
    job_offer = JobOffer.new parameters, status: JobStatus.pending
    job_offer.employer = current_user.manifestation.employer unless parameters[:employer_id]
    if(!(job_offer.employer && job_offer.employer.can_create_job_offer?(job_offer.category)))
      job_offer.employer.add_one_single_booked_job
    end

    if job_offer.save && !job_offer.employer.can_create_job_offer?(job_offer.category)
      JobOffersMailer.new_single_job_offer_email(job_offer, job_offer.employer).deliver
    elsif job_offer.save && job_offer.employer.can_create_job_offer?(job_offer.category)
      JobOffersMailer.new_job_offer_email(job_offer).deliver
    elsif parameters[:flexible_start_date]
      job_offer.flexible_start_date = true
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
        JobOffersMailer.job_will_expire_email(offer).deliver
      elsif offer.expiration_date <= Date.today
        offer.update_column :status_id, JobStatus.closed.id
        JobOffersMailer.job_expired_email(offer).deliver
      end
    end
  end
  
  def self.export_csv
    "XXX hello hallo XXX"
  end
  
  def default_values
    self.status ||= JobStatus.pending
  end

  def can_be_created
    if(!(employer && employer.can_create_job_offer?(category)))
      employer.add_one_single_booked_job
    end
    return true
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

  def check_remaining_applications
    if vacant_posts == 0
      if update({ status: JobStatus.active })
        applications.each do | application |
          application.decline
        end
      else
        return false
      end
    end
    return true
  end

  def prolong
    update_column :prolonged_at, Date.current
    update_column :prolonged, true
    update_column :prolong_requested, false
    update_column :status_id, JobStatus.active.id
    JobOffersMailer.job_prolonged_email(self).deliver
  end

  def immediately_prolongable
    category_id < 2 && !prolonged
  end

  def expiration_date
    (prolonged_at || created_at).to_date + 4.weeks
  end

  def fire(student)
    assigned_students.delete student
    save!
    update!({status: JobStatus.active})
  end

  def accept_application(application)
    new_assigned_students = assigned_students << application.student
    if update({ assigned_students: new_assigned_students })
      application.delete
      update!({ start_date: Date.current }) if flexible_start_date
      ApplicationsMailer.application_accepted_student_email(application).deliver
      JobOffersMailer.job_student_accepted_email(self).deliver
      return true
    else
      return false
    end
  end

  def category
    CATEGORIES[category_id]
  end

  def state
    STATES[state_id]
  end

  def student_group
    Student::GROUPS[student_group_id]
  end

  def minimum_degree
    Student::GRADUATIONS[graduation_id]
  end
end
