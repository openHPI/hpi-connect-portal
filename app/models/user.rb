# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  is_student          :boolean
#  lastname            :string(255)
#  firstname           :string(255)
#  role_id             :integer          default(1), not null
#  chair_id            :integer
#

class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :trackable, :openid_authenticatable

    has_many :applications
    has_many :job_offers, through: :applications
    belongs_to :role
    belongs_to :chair

    has_one :profile, :class_name => "Student"

    validates :email, uniqueness: { case_sensitive: false }
    validates :identity_url, uniqueness: true

    def self.build_from_identity_url(identity_url)
        username = identity_url.reverse[0..identity_url.reverse.index('/')-1].reverse

        first_name = username.split('.').first.capitalize
        last_name = username.split('.').second.capitalize
        email = username + '@student.hpi.uni-potsdam.de'

        user = User.new(identity_url: identity_url, email: email, firstname: first_name, lastname: last_name, is_student: true)
    end

    def self.create_student_from_identity_url(identity_url)
        username = identity_url.reverse[0..identity_url.reverse.index('/')-1].reverse

        first_name = username.split('.').first.capitalize
        last_name = username.split('.').second.capitalize
        email = username + '@student.hpi.uni-potsdam.de'

        User.createStudent(indentity_url, email, first_name, last_name)
    end

    def applied?(job_offer)
        applications.find_by_job_offer_id job_offer.id
    end

    def student?
        role.name == 'Student'
    end

    def research_assistant?
        role.name == 'Research Assistant'
    end

    def admin?
        role.name == 'Admin'
    end

    def self.search_students_for_string(string)
        return User.where("is_student = true
                AND
                (lower(firstname) LIKE ?
                OR lower(lastname) LIKE ?)", string.downcase, string.downcase)
    end

    def self.create_student(identity_url, email, first_name, last_name)
        user = User.create(identity_url: identity_url, email: email, firstname: first_name, lastname: last_name, is_student: true)
        user.profile = Student.create()
        user
    end
end
