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
#  chair_id               :integer
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
#  photo_file_name        :date
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :date
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :date
#  status                 :integer
#  user_status_id         :integer
#

class User < ActiveRecord::Base
    attr_accessor :username
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :trackable, :openid_authenticatable

    has_many :applications
    has_many :job_offers, through: :applications
    has_many :programming_languages_users
    has_many :programming_languages, :through => :programming_languages_users
    accepts_nested_attributes_for :programming_languages
    has_many :languages_users
    has_many :languages, :through => :languages_users
    accepts_nested_attributes_for :languages
    
    belongs_to :role
    belongs_to :chair
    belongs_to :user_status

    has_attached_file   :photo,
                        :url  => "/assets/students/:id/:style/:basename.:extension",
                        :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

    has_attached_file   :cv,
                        :url  => "/assets/students/:id/:style/:basename.:extension",
                        :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
    validates_attachment_content_type :cv, :content_type => ['application/pdf']

    validates :email, uniqueness: { case_sensitive: false }
    validates :identity_url, uniqueness: true
    validates :firstname, :lastname, presence: true
    validates :role, presence: true
    validates  :semester, :academic_program, :education, presence: true, :if => :student?
    validates_inclusion_of :semester, :in => 1..12, :if => :student?
   
    scope :students, -> { joins(:role).where('roles.name = ?', 'Student')}
    scope :staff, -> { joins(:role).where('roles.name = ?', 'Staff')}

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

    def self.build_from_identity_url(identity_url)
        username = identity_url.reverse[0..identity_url.reverse.index('/')-1].reverse

        first_name = username.split('.').first.capitalize
        last_name = username.split('.').second.capitalize
        email = username + '@student.hpi.uni-potsdam.de'

        # semester, academic_program and education are required to create a user with the role student
        # If another role is chosen, these attributes are still present, but it does not matter
        User.new(
            identity_url: identity_url, 
            email: email, 
            firstname: first_name, 
            lastname: last_name, 
            semester: 1,
            academic_program: "unknown",
            education: "unknown",
            role: Role.where(name: "Student").first)
    end

    def applied?(job_offer)
        applications.find_by_job_offer_id job_offer.id
    end

    def student?
        role && role.name == 'Student'
    end

    def staff?
        role && role.name == 'Staff'
    end

    def admin?
        role && role.name == 'Admin'
    end

    def self.search_student(string)
        string = string.downcase
        search_results = User.where("
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
                string, string, string, string, string,
                string, string, string, string, string)
        search_results += search_students_by_language_identifier(:programming_languages, string)
        search_results += search_students_by_language_identifier(:languages, string)
        search_results.uniq.sort_by{|x| [x.lastname, x.firstname]}
    end

    def self.search_students_by_language_identifier(language_identifier, string)
        key = language_identifier.to_s + ".name"
        User.joins(language_identifier).where(key + " ILIKE ?", string).sort_by{|x| [x.lastname, x.firstname]}
    end

    def self.search_students_by_language_and_programming_language(language_array, programming_language_array)
        search_students_for_mulitple_languages_and_identifiers(:languages, language_array) & search_students_for_mulitple_languages_and_identifiers(:programming_languages, programming_language_array)
    end

    def self.search_students_for_mulitple_languages_and_identifiers(language_identifier, languages)
        result = User.all

        if !languages.nil?
            languages.each do |language|
                result = result & search_students_by_language_identifier(language_identifier, language)
            end
        end

        result
    end
end
