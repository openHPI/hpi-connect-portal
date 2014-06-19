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
      :request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile',
      :access_token_path => '/uas/oauth/accessToken' }

  VISIBILITYS = ['nobody','employers_only','employers_and_students']    
  ACADEMIC_PROGRAMS = ['bachelor', 'master', 'phd', 'alumnus']
  GRADUATIONS = ['abitur',  'bachelor', 'master', 'phd']
  EMPLOYMENT_STATUSES = ['jobseeking', 'employed', 'employedseeking', 'nointerest']

  attr_accessor :username

  has_one :user, as: :manifestation, dependent: :destroy

  has_many :applications, dependent: :destroy
  has_many :job_offers, through: :applications
  has_many :programming_languages_users, dependent: :destroy
  has_many :programming_languages, through: :programming_languages_users
  has_many :languages_users, dependent: :destroy
  has_many :languages, through: :languages_users
  has_many :employers_newsletter_informations, dependent: :destroy
  has_many :possible_employers, through: :employers_newsletter_information
  has_many :programming_languages_newsletter_informations, dependent: :destroy
  has_many :possible_programming_language, through: :programming_languages_newsletter_information
  has_many :assignments, dependent: :destroy
  has_many :assigned_job_offers, through: :assignments, source: :job_offer
  has_many :cv_jobs, dependent: :destroy
  has_many :cv_educations, dependent: :destroy

  accepts_nested_attributes_for :user, update_only: true
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :programming_languages
  accepts_nested_attributes_for :cv_jobs, allow_destroy: true, reject_if: proc { |attributes| CvJob.too_blank? attributes }
  accepts_nested_attributes_for :cv_educations, allow_destroy: true, reject_if: proc { |attributes| CvEducation.too_blank? attributes }

  delegate :firstname, :lastname, :full_name, :email, :activated, :photo, to: :user

  validates :semester, :academic_program_id, presence: true
  validates_inclusion_of :semester, :in => 1..20

  scope :active, -> { joins(:user).where('users.activated = ?', true) }
  scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
  scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct students.*") }
  scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct students.*") }
  scope :filter_academic_program, -> academic_program_id { where('academic_program_id = ?', academic_program_id.to_f)}
  scope :filter_graduation, -> graduation_id { where('graduation_id >= ?', graduation_id.to_f)}
  scope :search_students, -> string { where("
          (lower(firstname) LIKE ?
          OR lower(lastname) LIKE ?
          OR lower(email) LIKE ?
          OR lower(academic_program_id) LIKE ?
          OR lower(graduation_id) LIKE ?
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

  def academic_program
    ACADEMIC_PROGRAMS[academic_program_id]
  end

  def graduation
    GRADUATIONS[graduation_id]
  end

  def visibility
    VISIBILITYS[visibility_id]
  end

  def update_from_linkedin(linkedin_client)
    userdata = linkedin_client.profile(fields: ["public_profile_url", "languages", 
      "three_current_positions", "date-of-birth", "first-name", "last-name", "email-address", "skills"])
    if !userdata["three_current_positions"].nil? && employment_status == "jobseeking"
      update!(employment_status_id: EMPLOYMENT_STATUSES.index("employedseeking"))
    end
    update_attributes!(
      { birthday: userdata["date-of-birth"], 
        linkedin: userdata["public_profile_url"],
        user_attributes: {
          firstname: userdata["first-name"], 
          lastname: userdata["last-name"],
          email: userdata["email-address"]
        }.reject{|key, value| value.blank? || value.nil?}
        }.reject{|key, value| value.blank? || value.nil?})
    update_programming_language userdata["skills"]["all"] unless userdata["skills"].nil?
  end

  def update_programming_language(skills)
    programming_language_names = (skills.reject{|skill_wrapper| ProgrammingLanguage.where(name: skill_wrapper["skill"]["name"]).empty? }).map{|programming_language_wrap| programming_language_wrap["skill"]["name"]}
    programming_language_names.each do |programming_language_name| 
      unless ProgrammingLanguagesUser.does_skill_exist_for_programming_language_and_student(ProgrammingLanguage.find_by_name(programming_language_name), self)
        ProgrammingLanguagesUser.create(student_id: self.id, programming_language_id: ProgrammingLanguage.find_by_name(programming_language_name).id, skill:3) 
      end
    end
  end

  def self.linkedin_request_token_for_callback(url) 
    self.create_linkedin_client.request_token(oauth_callback: url)
  end

  def self.create_linkedin_client
    LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET, LINKEDIN_CONFIGURATION)
  end
end
