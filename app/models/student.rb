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
#  visibility_id          :integer          default(0), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#

class Student < ActiveRecord::Base

  LINKEDIN_KEY = "77sfagfnu662bn"
  LINKEDIN_SECRET = "7HEaILeWfmauzlKp"
  LINKEDIN_CONFIGURATION = { :site => 'https://api.linkedin.com',
      :authorize_path => '/uas/oauth/authenticate',
      :request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile',
      :access_token_path => '/uas/oauth/accessToken' }

  VISIBILITYS = ['nobody','employers_only','employers_and_students','students_only']    
  ACADEMIC_PROGRAMS = ['bachelor', 'master', 'phd', 'alumnus']
  GRADUATIONS = ['abitur',  'bachelor', 'master', 'phd']
  EMPLOYMENT_STATUSES = ['jobseeking', 'employed', 'employedseeking', 'nointerest']
  DSCHOOL_STATUSES = ['nothing', 'introduction', 'basictrack', 'advancedtrack']
  GROUPS = ['hpi', 'dschool', 'both']
  NEWSLETTER_DELIVERIES_CYCLE = 1.week

  attr_accessor :username

  has_one :user, as: :manifestation, dependent: :destroy

  has_many :applications, dependent: :destroy
  has_many :job_offers, through: :applications
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
          
  def self.group_id(group_name)
    GROUPS.index(group_name)
  end        

  def application(job_offer)
    applications.where(job_offer: job_offer).first
  end

  def applied?(job_offer)
    !!application(job_offer)
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

  def update_from_linkedin(linkedin_client)
    userdata = linkedin_client.profile(fields: ["public_profile_url", "first-name", "last-name", "positions"])
    update_attributes!(
      {
        linkedin: userdata["public_profile_url"],
        user_attributes: {
          firstname: userdata["first-name"], 
          lastname: userdata["last-name"],
        }.reject{|key, value| value.blank? || value.nil?}
      }.reject{|key, value| value.blank? || value.nil?})
    update_cv_jobs userdata["positions"]["all"] unless userdata["positions"].nil?
  end

  def update_cv_jobs(jobs)
    jobs.each do |job|
      description = !job["summary"].nil? ? job["summary"] : " "
      start_date = !job["start_date"].nil? ? (!job["start_date"]["month"].nil? ? Date.new(job["start_date"]["year"].to_i, job["start_date"]["month"].to_i) : Date.new(job["start_date"]["year"].to_i)) : nil
      end_date = !job["end_date"].nil? ? (!job["end_date"]["month"].nil? ? Date.new(job["end_date"]["year"].to_i, job["end_date"]["month"].to_i) : Date.new(job["end_date"]["year"].to_i)) : nil
      current = (job["is_current"].to_s == 'true')
      update_attributes!(
        cv_jobs: self.cv_jobs.push(
          CvJob.new(
            student: self,
            employer: job["company"]["name"],
            position: job["title"],
            description: description,
            start_date: start_date,
            end_date: end_date,
            current: current)
        )
      )
    end
  end

  def self.linkedin_request_token_for_callback(url) 
    self.create_linkedin_client.request_token(oauth_callback: url)
  end

  def self.create_linkedin_client
    LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET, LINKEDIN_CONFIGURATION)
  end

  def self.apply_saved_scopes(job_offers, saved_scopes)
    saved_scopes.each do |key, value|
      if key == :state
        job_offers = job_offers.filter_state(value)
      end
      if key == :employer
        job_offers = job_offers.filter_employer(value)
      end
      if key == :category
        job_offers = job_offers.filter_category(value)
      end
      if key == :graduations
        job_offers = job_offers.filter_graduations(value)
      end
      if key == :start_date
        job_offers = job_offers.filter_start_date(value)
      end
      if key == :end_date
        job_offers = job_offers.filter_end_date(value)
      end
      if key == :time_effort
        job_offers = job_offers.filter_time_effort(value)
      end
      if key == :compensation
        job_offers = job_offers.filter_compensation(value)
      end
      if key == :language_ids
        job_offers = job_offers.filter_languages(value)
      end
      if key == :programming_language_ids
        job_offers = job_offers.filter_programming_languages(value)
      end
      if key == :student_group
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
end
