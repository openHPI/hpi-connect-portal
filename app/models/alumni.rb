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
    errors.add(:alumni_email, I18n.t("errors.messages.taken")) if alumni_email && User.where("lower(alumni_email) LIKE ?", alumni_email.downcase).exists?
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

  # Attemps to match alumnus with a user account by alumni mail address
  # Receives row of a CSV file with the alumnus' data
  # If successful, the following fields are updated: private mail address, current employer, current position
  # If not, row is returned unchanged

  # TODO Move to a helper
  def self.update_alumni_data(row)
    byebug
    matched_user = User.where("LOWER(alumni_email) LIKE ?", row[7].gsub("@hpi-alumni.de", "").downcase).first

    if not matched_user
      # TODO Extract alumni mail from other mails
      matched_user = User.where("LOWER(alumni_email) LIKE ?", (row[1]+"."+row[0]).downcase).first
    end

    if matched_user
      # Update private email
      row[6] = matched_user.email

      # Update emailverteiler
      if row[9]
        row[9].gsub(row[6], matched_user.email)
      else
        row[9] = row[6]+";"
        row[10] = nil
      end

      current_work = matched_user.manifestation.get_current_enterprises_and_positions
      row[11] = current_work[0]
      row[12] = current_work[1]
    end

    return row
  end
end
