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
#  lastname            :string(255)
#  firstname           :string(255)
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer
#  photo_updated_at    :datetime
#  cv_file_name        :string(255)
#  cv_content_type     :string(255)
#  cv_file_size        :integer
#  cv_updated_at       :datetime
#  status              :integer
#  frequency           :integer          default(1), not null
#  manifestation_id    :integer
#  manifestation_type  :string(255)
#

class User < ActiveRecord::Base
  include UserScopes

  attr_accessor :should_redirect_to_profile
  attr_accessor :username

  belongs_to :manifestation, polymorphic: true, touch: true, :dependent => :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates :firstname, :lastname, presence: true

  has_attached_file   :photo,
            :url  => "/assets/students/:id/:style/:basename.:extension",
            :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension",
            :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

  has_attached_file   :cv,
            :url  => "/assets/students/:id/:style/:basename.:extension",
            :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
  validates_attachment_content_type :cv, :content_type => ['application/pdf']

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
    manifestation_type.downcase == 'student'
  end

  def staff?
    manifestation_type.downcase == 'staff'
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
end
