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
#  chair_id            :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  vacant_posts        :integer          default(1)

class JobOffer < ActiveRecord::Base
  include Bootsy::Container
  before_save :default_values

  has_many :applications
  has_many :users, through: :applications
  has_and_belongs_to_many :assigned_students, class_name: "User"
  has_and_belongs_to_many :programming_languages
  has_and_belongs_to_many :languages
  belongs_to :chair
  belongs_to :responsible_user, class_name: "User"
  belongs_to :status, class_name: "JobStatus"

  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :languages

  validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
  validates :compensation, :time_effort, numericality: true
  validates_datetime :end_date, :on_or_after => :start_date, :allow_blank => :end_date

  self.per_page = 5

  scope :pending, -> { where(status_id: JobStatus.pending.id) }
  scope :open, -> { where(status_id: JobStatus.open.id) }
  scope :running, -> { where(status_id: JobStatus.running.id) }
  scope :completed, -> { where(status_id: JobStatus.completed.id) }

  scope :filter_chair, -> chair { where(chair_id: chair) }
  scope :filter_start_date, -> start_date { where('start_date >= ?', Date.parse(start_date)) }
  scope :filter_end_date, -> end_date { where('end_date <= ?', Date.parse(end_date)) }
  scope :filter_time_effort, -> time_effort { where('time_effort <= ?', time_effort.to_f) }
  scope :filter_compensation, -> compensation { where('compensation >= ?', compensation.to_f) }
  scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct job_offers.*") }
  scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct job_offers.*") }
  scope :search, -> search_string { includes(:programming_languages, :chair).where('lower(title) LIKE ? OR lower(job_offers.description) LIKE ? OR lower(chairs.name) LIKE ? OR lower(programming_languages.name) LIKE ?', "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase).references(:programming_languages,:chair) }

  def default_values
    self.status ||= JobStatus.pending
    self.vacant_posts ||= 1
  end

  def self.sort(order_attribute)
    if order_attribute == "chair"
      includes(:chair).order("chairs.name ASC")
    else
      order('job_offers.created_at DESC')
    end
  end

  def completed?
    status == JobStatus.completed
  end

  def pending?
    status == JobStatus.pending
  end

  def open?
    status == JobStatus.open
  end

  def running?
    status == JobStatus.running
  end

  def editable?
    self.pending? or self.open?
  end
end
