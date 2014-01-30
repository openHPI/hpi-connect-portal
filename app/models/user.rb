# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  identity_url           :string(255)
#  lastname               :string(255)
#  firstname              :string(255)
#  role_id                :integer          default(1), not null
#  employer_id            :integer
#  semester               :integer
#  academic_program       :string(255)
#  birthday               :date
#  education              :text
#  additional_information :text
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :datetime
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :datetime
#  status                 :integer
#  user_status_id         :integer
#  employment_start_date  :date
#

class User < ActiveRecord::Base
  attr_accessor :username
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :trackable, :openid_authenticatable

  has_many :applications
  has_many :job_offers, through: :applications
  has_and_belongs_to_many :assigned_job_offers, class_name: "JobOffer"
  has_many :programming_languages_users
  has_many :programming_languages, :through => :programming_languages_users
  accepts_nested_attributes_for :programming_languages
  has_many :languages_users
  has_many :languages, :through => :languages_users
  has_many :possible_employers, :through => :employers_newsletter_information
  has_many :possible_programming_language, :through => :programming_languages_newsletter_information 
  accepts_nested_attributes_for :languages

  attr_accessor :should_redirect_to_profile

  belongs_to :role
  belongs_to :employer
  belongs_to :user_status

  has_attached_file   :photo,
            :url  => "/assets/students/:id/:style/:basename.:extension",
            :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension",
            :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

  has_attached_file   :cv,
            :url  => "/assets/students/:id/:style/:basename.:extension",
            :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
  validates_attachment_content_type :cv, :content_type => ['application/pdf']

  validates :email, uniqueness: { case_sensitive: false }
  validates :identity_url, uniqueness: true
  validates :firstname, :lastname, presence: true
  validates :role, presence: true
  validates :employer, presence: true, :if => :staff?
  validates :semester, :academic_program, :education, presence: true, :if => :student?
  validates_inclusion_of :semester, :in => 1..12, :if => :student?

  scope :students, -> { joins(:role).where('roles.name = ?', 'Student') }
  scope :staff, -> { joins(:role).where('roles.name = ?', 'Staff') }

  scope :update_immediately, ->{joins(:role).where('frequency = ? AND roles.name= ?', 1, 'Student')}
  scope :filter_semester, -> semester {where("semester IN (?)", semester.split(',').map(&:to_i))}
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
              string.downcase, string.downcase, string.downcase, string.downcase, string.downcase)}

  def eql?(other)
    other.kind_of?(self.class) && self.id == other.id
  end

  def hash
    self.id.hash
  end

  def name
    "#{firstname} #{lastname}"
  end

  def applied?(job_offer)
    applications.find_by_job_offer_id job_offer.id
  end

  def student?
    role && role.student_role?
  end

  def staff?
    role && role.staff_role?
  end

  def admin?
    role && role.admin_role?
  end

  def name
     return firstname + " " +lastname
  end

  def promote(new_role, employer=nil, should_be_deputy=false)
    new_role ||= self.role
    if !employer.nil?
      self.update!(employer: employer, role: new_role)
      if should_be_deputy
        employer.update!(deputy: self)
      end
    else
      self.update!(role: new_role)
    end
  end

  def self.build_from_identity_url(identity_url)
    username = identity_url.reverse[0..identity_url.reverse.index('/')-1].reverse

    splitted_name = username.split('.')
    first_name = splitted_name.first.capitalize
    last_name = splitted_name.second.capitalize
    email = username + '@student.hpi.uni-potsdam.de'

    # semester, academic_program and education are required to create a user with the role student
    # If another role is chosen, these attributes are still present, but it does not matter
    new_user = User.new(
      identity_url: identity_url,
      email: email,
      firstname: first_name,
      lastname: last_name,
      semester: 1,
      academic_program: "unknown",
      education: "unknown",
      role: Role.where(name: "Student").first)

    new_user.should_redirect_to_profile = true

    return new_user
  end

  def self.search_student(string)
    string = string.downcase
    search_results = User.search_students string
    search_results += search_students_by_language_identifier :programming_languages, string
    search_results += search_students_by_language_identifier :languages, string
    search_results.uniq.sort_by{|student| [student.lastname, student.firstname]}
  end

  def self.search_students_by_language_identifier(language_identifier, string)
    key = language_identifier.to_s + ".name"
    User.joins(language_identifier).where(key + " ILIKE ?", string).sort_by{|student| [student.lastname, student.firstname]}
  end

  def self.search_students_by_language_and_programming_language(language_array, programming_language_array)
    search_students_for_multiple_languages_and_identifiers(:languages, language_array) & search_students_for_multiple_languages_and_identifiers(:programming_languages, programming_language_array)
  end

  def self.search_students_for_multiple_languages_and_identifiers(language_identifier, languages)
    result = User.all

    if !languages.nil?
      languages.each do |language|
        result = result & search_students_by_language_identifier(language_identifier, language)
      end
    end

    return result
  end

  def set_role(role_level, employer)
    case role_level.to_i
      when 4
        self.set_role_to_deputy(employer)
      when 3
        self.set_role_to_admin
      when 2
        self.set_role_to_staff(employer)
      when 1
        self.set_role_to_student
    end
  end

  def set_role_to_deputy(employer)
    self.update(:employer => employer, :role => Role.find_by_level(2))
    employer.update(:deputy => self)
  end

  def set_role_to_admin
    self.update(:role => Role.find_by_level(3))
  end

  def set_role_to_staff(employer)
    self.update(:role => Role.find_by_level(2), :employer => employer)
  end

  def set_role_to_student
    self.update(:role => Role.find_by_level(1), :employer => nil)
  end
end
