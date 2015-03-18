# == Schema Information
#
# Table name: alumnis
#
#  id           :integer          not null, primary key
#  firstname    :string(255)
#  lastname     :string(255)
#  email        :string(255)      not null
#  alumni_email :string(255)      not null
#  token        :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Alumni < ActiveRecord::Base
  
  validates :email, presence: true
  validates :alumni_email, presence: true, uniqueness: { case_sensitive: false }
  validates :token, presence: true, uniqueness: { case_sensitive: true }
  validate :uniqueness_of_alumni_email_on_user
  scope :firstname, -> firstname {where("lower(firstname) LIKE ?", firstname.downcase)}
  scope :lastname, -> lastname {where("lower(lastname) LIKE ?", lastname.downcase)}
  scope :email, -> email {where("lower(email) LIKE ?", email.downcase)}
  scope :alumni_email, -> alumni_email {where("lower(alumni_email) LIKE ?", alumni_email.downcase)}

  def self.create_from_row(row)
    row[:firstname] ||= row[:alumni_email].split('.')[0].capitalize
    row[:lastname] ||= row[:alumni_email].split('.')[1].capitalize
    alumni = Alumni.new firstname: row[:firstname], lastname: row[:lastname], email: row[:email], alumni_email: row[:alumni_email]
    alumni.generate_unique_token
    if alumni.save
      begin
        AlumniMailer.creation_email(alumni).deliver
        return :created
      rescue => e
        alumni.delete
        logger.error "Sending mail of #{alumni.id} to #{alumni.email} raised the exception #{e.class.name} : #{e.message}"
      end
    end
    return alumni
  end

  def self.email_invalid? email
    email.include?("@hpi-alumni") || email.include?("@student.hpi") || email.include?("@hpi.")
  end
  def uniqueness_of_alumni_email_on_user
    errors.add(:alumni_email, 'is already in use by another user.') if User.exists? alumni_email: alumni_email
  end

  def generate_unique_token
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 while Alumni.exists? token: code
    self.token = code
  end

  def link(user)
    user.update_column :alumni_email, alumni_email
    user.update_column :activated, true
    self.destroy
  end

  def send_reminder
    AlumniMailer.reminder_email(self).deliver
  end
end
