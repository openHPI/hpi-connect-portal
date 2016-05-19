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

class Student < ActiveRecord::Base

  VISIBILITYS = ['nobody','employers_only','employers_and_students','students_only']
  ACADEMIC_PROGRAMS = ['bachelor', 'master', 'phd', 'alumnus']
  GRADUATIONS = ['abitur',  'bachelor', 'master', 'phd']
  EMPLOYMENT_STATUSES = ['jobseeking', 'employed', 'employedseeking', 'nointerest']
  DSCHOOL_STATUSES = ['nothing', 'introduction', 'basictrack', 'advancedtrack']
  GROUPS = ['hpi', 'dschool', 'both']
  NEWSLETTER_DELIVERIES_CYCLE = 1.week

  attr_accessor :username

  has_one :user, as: :manifestation, dependent: :destroy

  has_many :programming_languages_users, dependent: :destroy
  has_many :programming_languages, through: :programming_languages_users
  has_many :languages_users, dependent: :destroy
  has_many :languages, through: :languages_users
  has_many :assignments, dependent: :destroy
  has_many :assigned_job_offers, through: :assignments, source: :job_offer
  has_many :cv_jobs, dependent: :destroy
  has_many :cv_educations, dependent: :destroy
  has_many :newsletter_orders, dependent: :destroy
  has_many :ratings, dependent: :destroy

  accepts_nested_attributes_for :user, update_only: true
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :cv_jobs, allow_destroy: true, reject_if: proc { |attributes| CvJob.too_blank? attributes }
  accepts_nested_attributes_for :cv_educations, allow_destroy: true, reject_if: proc { |attributes| CvEducation.too_blank? attributes }

  delegate :firstname, :lastname, :full_name, :email, :alumni_email, :activated, :photo, to: :user

  validates :academic_program_id, presence: true
  validates_inclusion_of :semester, in: 1..20, allow_nil: true

  scope :active, -> { joins(:user).where('users.activated = ?', true) }
  scope :visible_for_all, -> visibility_id { where('visibility_id < 0')}
  scope :visible_for_nobody, -> {where 'visibility_id = ?', VISIBILITYS.find_index('nobody')}
  scope :visible_for_students, -> {where 'visibility_id = ? or visibility_id = ?',VISIBILITYS.find_index('employers_and_students'),VISIBILITYS.find_index('students_only')}
  scope :visible_for_employers, ->  { where('visibility_id > ? or visibility_id = ?', VISIBILITYS.find_index('employers_only'), VISIBILITYS.find_index('employers_and_students'))}
  scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
  scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct students.*") }
  scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct students.*") }
  scope :filter_academic_program, -> academic_program_id { where('academic_program_id = ?', academic_program_id.to_f)}
  scope :filter_graduation, -> graduation_id { where('graduation_id >= ?', graduation_id.to_f)}
  scope :update_immediately, -> { where(frequency: 1) }
  scope :filter_students, -> q { joins(:user).where("
          (lower(firstname) LIKE ?
          OR lower(lastname) LIKE ?
          OR lower(email) LIKE ?
          OR lower(homepage) LIKE ?
          OR lower(github) LIKE ?
          OR lower(facebook) LIKE ?
          OR lower(xing) LIKE ?
          OR lower(linkedin) LIKE ?)
          ",   q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase)}
  scope :filter_employer, -> employer { joins(:cv_jobs).where("lower(employer) IN (?)", employer.split(',').map(&:downcase))}

  def self.group_id(group_name)
    GROUPS.index(group_name)
  end

  def employment_status
    EMPLOYMENT_STATUSES[employment_status_id]
  end

  def academic_program
    ACADEMIC_PROGRAMS[academic_program_id]
  end

  def graduation
    GRADUATIONS[graduation_id]
  end

  def visibility
    VISIBILITYS[visibility_id]
  end

  def dschool_status
    DSCHOOL_STATUSES[dschool_status_id]
  end

  def group
    GROUPS[group_id]
  end

  def self.apply_saved_scopes(job_offers, saved_scopes)
    saved_scopes.each do |key, value|
      case key
      when :state
        job_offers = job_offers.filter_state(value)
      when :employer
        job_offers = job_offers.filter_employer(value)
      when :category
        job_offers = job_offers.filter_category(value)
      when :graduations
        job_offers = job_offers.filter_graduations(value)
      when :start_date
        job_offers = job_offers.filter_start_date(value)
      when :end_date
        job_offers = job_offers.filter_end_date(value)
      when :time_effort
        job_offers = job_offers.filter_time_effort(value)
      when :compensation
        job_offers = job_offers.filter_compensation(value)
      when :language_ids
        job_offers = job_offers.filter_languages(value)
      when :programming_language_ids
        job_offers = job_offers.filter_programming_languages(value)
      else
        job_offers = job_offers.filter_student_group(value)
      end
    end
    return job_offers
  end

  def self.deliver_newsletters
    possible_job_offers = JobOffer.active.where("created_at > ?", Student::NEWSLETTER_DELIVERIES_CYCLE.ago)
    Student.all.each do |student|
      student.newsletter_orders.each do |newsletter_order|
        matching_jobs = apply_saved_scopes(possible_job_offers, newsletter_order.search_params)
        if matching_jobs.any?
          StudentsMailer.newsletter(student, matching_jobs, newsletter_order).deliver
        end
      end
    end
  end

  def self.export_alumni
    CSV.generate(headers: true) do |csv|
      shared_attributes = %w{lastname firstname alumni_email email}
      headers = ["registered?"] + shared_attributes + %w{graduation current_enterprise(s) current_position(s)}
      csv << headers
      csv = self.add_registered_alumni_to_csv(csv, shared_attributes)
      csv << [I18n.t('activerecord.attributes.alumni.following_alumni_are_not_registered_yet'), '', '', '']
      csv = self.add_unregistered_alumni_to_csv(csv, shared_attributes)
    end
  end

  def self.add_registered_alumni_to_csv(csv, attributes)
    find_each do |student|
      if student.user.alumni?
        current_enterprises_and_positions = student.get_current_enterprises_and_positions
        alumni_attributes = ["yes"]
        alumni_attributes.concat(attributes.map{ |attr| student.send(attr)})
        alumni_attributes.push(I18n.t('activerecord.attributes.user.degrees.' + student.graduation))
        alumni_attributes.push(current_enterprises_and_positions[0])
        alumni_attributes.push(current_enterprises_and_positions[1])
        csv << alumni_attributes
      end
    end
    return csv
  end

  def self.add_unregistered_alumni_to_csv(csv, attributes)
    Alumni.find_each do |alumni|
      csv << ["no"].concat(attributes.map{ |attr| alumni.send(attr)})
    end
    return csv
  end

  def get_current_enterprises_and_positions
    current_jobs = cv_jobs.select {|job| job.current}
    current_enterprises = current_jobs.map {|job| job.employer}.join(', ')
    current_positions = current_jobs.map { |job| job.position}.join(', ')
    return [current_enterprises, current_positions]
  end
end
