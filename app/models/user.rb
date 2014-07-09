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
  validates :firstname, :lastname, presence: true

  has_attached_file :photo, styles: { :medium => "300x300>", :thumb => "100x100>" }, default_url: "/assets/placeholder/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

  has_attached_file   :cv
  validates_attachment_content_type :cv, :content_type => ['application/pdf']

  after_destroy :clean_manifestation

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
