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
#  room_number         :string(255)
#  employer_id         :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  vacant_posts        :integer
#  flexible_start_date :boolean          default(FALSE)
#  category_id         :integer          default(0), not null
#  state_id            :integer          default(3), not null
#  graduation_id       :integer          default(2), not null
#  academic_program_id :integer
#  prolong_requested   :boolean          default(FALSE)
#  prolonged           :boolean          default(FALSE)
#  prolonged_at        :datetime
#

class JobOffer < ActiveRecord::Base
  include Bootsy::Container
  include JobOfferScopes

  ACADEMIC_PROGRAMS = ['bachelor', 'master', 'phd', 'alumnus']
  CATEGORIES = ['traineeship', 'sideline', 'graduate_job', 'HPI_assistant', 'working_student']
  STATES = ['ABROAD', 'BW', 'BY', 'BE', 'BB', 'HB', 'HH', 'HE', 'MV', 'NI', 'NW', 'RP', 'SL', 'SN', 'ST', 'SH', 'TH']
  GRADUATIONS = ['secondary_education', 'abitur',  'bachelor', 'master', 'phd'] 
  
  before_save :default_values

  has_many :applications
  has_many :students, through: :applications
  has_many :assignments
  has_many :assigned_students, through: :assignments, source: :student
  has_and_belongs_to_many :programming_languages
  has_and_belongs_to_many :languages
  belongs_to :employer
  belongs_to :responsible_user, class_name: "Staff"
  belongs_to :status, class_name: "JobStatus"

  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :languages

  validates :title, :description, :employer, :category, :state, :graduation_id, :start_date, presence: true
  validates :compensation, :time_effort, :vacant_posts, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :vacant_posts, :numericality => { greater_than_or_equal_to: 1 }, on: :create
  validates :responsible_user, presence: true
  validates_datetime :start_date, on_or_after: lambda { Date.current }, on_or_after_message: I18n.t("activerecord.errors.messages.in_future")
  validates_datetime :end_date, on_or_after: :start_date, allow_blank: :end_date
  validate :can_be_created, on: :create

  self.per_page = 15

  def self.create_and_notify(parameters, current_user)
    job_offer = JobOffer.new parameters, status: JobStatus.pending
    job_offer.responsible_user = current_user.manifestation unless parameters[:responsible_user_id]
    job_offer.employer = current_user.manifestation.employer unless parameters[:employer_id]
    if job_offer.save
      JobOffersMailer.new_job_offer_email(job_offer).deliver
    elsif parameters[:flexible_start_date]
      job_offer.flexible_start_date = true
    end
    return job_offer
  end

  def self.sort(order_attribute)
    if order_attribute == "employer"
      includes(:employer).order("employers.name ASC")
    else
      order('job_offers.created_at DESC')
    end
  end

  def default_values
    self.status ||= JobStatus.pending
    self.vacant_posts ||= 1
  end

  def can_be_created
    errors[:base] << I18n.t('job_offers.messages.cannot_create') unless employer && employer.can_create_job_offer?(category)
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
    update!({vacant_posts: vacant_posts + 1, status: JobStatus.active})
  end

  def accept_application(application)
    new_assigned_students = assigned_students << application.student
    if update({ assigned_students: new_assigned_students, vacant_posts: vacant_posts - 1 })
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

  def academic_program
    ACADEMIC_PROGRAMS[academic_program_id]
  end

  def minimum_degree
    GRADUATIONS[graduation_id]
  end
end
