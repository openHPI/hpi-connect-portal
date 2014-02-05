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
#  frequency              :integer          default(1), not null
#

class User < ActiveRecord::Base
  include UserScopes

  devise :trackable, :openid_authenticatable

  has_many :applications
  has_many :job_offers, through: :applications
  has_and_belongs_to_many :assigned_job_offers, class_name: "JobOffer"
  has_many :programming_languages_users
  has_many :programming_languages, through: :programming_languages_users
  accepts_nested_attributes_for :programming_languages
  has_many :languages_users
  has_many :languages, through: :languages_users
  has_many :possible_employers, through: :employers_newsletter_information
  has_many :possible_programming_language, through: :programming_languages_newsletter_information
  accepts_nested_attributes_for :languages

  attr_accessor :should_redirect_to_profile
  attr_accessor :username

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

  def eql?(other)
    other.kind_of?(self.class) && self.id == other.id
  end

  def hash
    self.id.hash
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

  def deputy?
    employer && Employer.exists?(deputy: self)
  end

  def admin?
    role && role.admin_role?
  end

  def full_name
    "#{firstname} #{lastname}"
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

    new_user
  end

  def set_role(role_level, employer)
    new_role = Role.find_by_level ((role_level == Role.deputy_level) ? Role.staff_level : role_level)

    update! employer: employer, role: new_role
    employer.update! deputy: self if role_level == Role.deputy_level
  end

  def set_role_from_staff_to_student(deputy_id)
    self.semester = 1 if not semester
    self.academic_program = 'unknown' if not academic_program
    self.education = 'unknown' if not education
    self.save!

    if deputy_id
      User.find(deputy_id).set_role Role.deputy_level, employer
    end
    set_role Role.student_level, nil
  end
end
