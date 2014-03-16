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
#

EMPLOYMENT_STATUSES = ['jobseeking', 'employed', 'employedseeking', 'nointerest']

class Student < ActiveRecord::Base

  has_one :user, as: :manifestation, dependent: :destroy

  has_many :applications
  has_many :job_offers, through: :applications
  has_many :programming_languages_users
  has_many :programming_languages, through: :programming_languages_users
  has_many :languages_users
  has_many :languages, through: :languages_users
  has_many :possible_employers, through: :employers_newsletter_information
  has_many :possible_programming_language, through: :programming_languages_newsletter_information
  has_many :assignments
  has_many :assigned_job_offers, through: :assignments, source: :job_offer

  accepts_nested_attributes_for :user, update_only: true
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :programming_languages

  delegate :firstname, :lastname, :full_name, :email, to: :user

  validates :semester, :academic_program, presence: true
  validates_inclusion_of :semester, :in => 1..12

  scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
  scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct users.*") }
  scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct users.*") }
  scope :search_students, -> string { where("
          (lower(firstname) LIKE ?
          OR lower(lastname) LIKE ?
          OR lower(email) LIKE ?
          OR lower(academic_program) LIKE ?
          OR lower(education) LIKE ?
          OR lower(homepage) LIKE ?
          OR lower(github) LIKE ?
          OR lower(facebook) LIKE ?
          OR lower(xing) LIKE ?
          OR lower(linkedin) LIKE ?)
          ",
          string.downcase, string.downcase, string.downcase, string.downcase, string.downcase,
          string.downcase, string.downcase, string.downcase, string.downcase, string.downcase) }
  scope :update_immediately, -> { where(frequency: 1) }

  def application(job_offer)
    applications.where(job_offer: job_offer).first
  end

  def applied?(job_offer)
    !!application(job_offer)
  end

  def employment_status
    EMPLOYMENT_STATUSES[employment_status_id]
  end
end
