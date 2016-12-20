# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

class User < ActiveRecord::Base
  include UserScopes

  has_secure_password

  belongs_to :manifestation, polymorphic: true, touch: true

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :alumni_email, uniqueness: { case_sensitive: false }, unless: Proc.new { |u| u.alumni_email.blank? }
  validates :firstname, :lastname, presence: true
  validate :non_hpi_email_on_alumni
  validate :non_duplicate_hpi_email, on: :create

  has_attached_file :photo, style: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/placeholder/:style/missing.png"
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
  validates_attachment_size :photo, less_than: 5.megabytes, message: "should be less than 5MB"

  has_attached_file   :cv
  validates_attachment_content_type :cv, content_type: ['application/pdf']

  after_destroy :clean_manifestation

  def non_hpi_email_on_alumni
    errors.add(:email, 'please choose a non-HPI-Email.') if alumni? && Alumni.email_invalid?(email)
  end

  def non_duplicate_hpi_email
    if email && email.include?("@student.hpi.de")
      errors.add(:email, I18n.t("errors.messages.taken")) if User.where("lower(email) LIKE ?", email.gsub("@student.hpi.de","@student.hpi.uni-potsdam.de").downcase).exists?
    elsif email && email.include?("@student.hpi.uni-potsdam.de")
      errors.add(:email, I18n.t("errors.messages.taken")) if User.where("lower(email) LIKE ?", email.gsub("@student.hpi.uni-potsdam.de","@student.hpi.de").downcase).exists?
    end
  end

  def eql?(other)
    other.kind_of?(self.class) && self.id == other.id
  end

  def hash
    self.id.hash
  end

  def role
    return admin? ? 'admin' : manifestation_type.downcase rescue 'student'
  end

  def student?
    manifestation_type == 'Student'
  end

  def staff?
    manifestation_type == 'Staff'
  end

  def admin?
    admin
  end

  def alumni?
    !alumni_email.blank?
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def clean_manifestation
    manifestation.destroy if manifestation
  end

  def set_random_password
    char_pool = [('a'..'z'),('A'..'Z'),('0'..'9'),['_', '-']].map { |char| char.to_a }.flatten
    new_password = ""
    (0..10).each { new_password += char_pool[rand(char_pool.length-1)]}
    self.update password: new_password, password_confirmation: new_password
    UsersMailer.new_password_mail(new_password, self).deliver
  end
end
