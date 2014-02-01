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
#  vacant_posts        :integer          default(1)
#  flexible_start_date :boolean          default(FALSE)
#

class JobOffer < ActiveRecord::Base
  include Bootsy::Container
  include JobOfferScopes

  before_save :default_values

  has_many :applications
  has_many :users, through: :applications
  has_and_belongs_to_many :assigned_students, class_name: "User"
  has_and_belongs_to_many :programming_languages
  has_and_belongs_to_many :languages
  belongs_to :employer
  belongs_to :responsible_user, class_name: "User"
  belongs_to :status, class_name: "JobStatus"

  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :languages

  validates :title, :description, :employer, :start_date, :time_effort, :compensation, presence: true
  validates :compensation, :time_effort, :numericality => { :greater_than_or_equal_to => 0 }
  validates :responsible_user, presence: true
  validates_datetime :start_date, on_or_after: lambda { Date.current }, on_or_after_message: I18n.t("activerecord.errors.messages.in_future")
  validates_datetime :end_date, on_or_after: :start_date, allow_blank: :end_date

  self.per_page = 5

  def default_values
    self.status ||= JobStatus.pending
    self.vacant_posts ||= 1
  end

  def self.create_and_notify(parameters, current_user)
    job_offer = JobOffer.new parameters, status: JobStatus.pending
    job_offer.responsible_user = current_user
    if !parameters[:employer_id]
      job_offer.employer = current_user.employer
    end

    if job_offer.save
      JobOffersMailer.new_job_offer_email(job_offer).deliver
      JobOffersMailer.inform_interested_students_immediately(job_offer)
    else
      if parameters[:flexible_start_date]
        job_offer.flexible_start_date = true
      end
    end
    job_offer
  end

  def self.sort(order_attribute)
    if order_attribute == "employer"
      includes(:employer).order("employers.name ASC")
    else
      order('job_offers.created_at DESC')
    end
  end

  def completed?
    status && status == JobStatus.completed
  end

  def pending?
    status && status == JobStatus.pending
  end

  def open?
    status && status == JobStatus.open
  end

  def running?
    status && status == JobStatus.running
  end

  def editable?
    self.pending? || self.open?
  end

  def human_readable_compensation
    (self.compensation == 10.0) ? I18n.t('job_offers.default_compensation') : self.compensation.to_s + " " + I18n.t("job_offers.compensation_description")
  end

  def check_remaining_applications
    if vacant_posts == 0
      if update({ status: JobStatus.running })
        applications.each do | application |
          application.decline
        end
      else
        false
      end
    end
    true
  end

  def prolong(date)
    if running? && end_date < date
      update_column :end_date, date
      JobOffersMailer.job_prolonged_email(self).deliver
      true
    else
      false
    end
  end
end
