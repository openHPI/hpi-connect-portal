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

class User < ApplicationRecord

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

  scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
  scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct users.*") }
  scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct users.*") }
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

  def non_hpi_email_on_alumni
    errors.add(:email, I18n.t("errors.messages.non_hpi_mail")) if alumni? && Alumni.email_invalid?(email)
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
    char_pool = [('a'..'z'),('A'..'Z'),('0'..'9')].map { |char| char.to_a }.flatten
    special_char_pool = ['_', '-', '&', '!', '$', '#', '/', '\\']
    new_password = ""
    (0..10).each { new_password += char_pool[rand(char_pool.length-1)]}
    (0..rand(2)).each { new_password[rand(10)] = special_char_pool[rand(special_char_pool.length-1)]}
    self.update password: new_password, password_confirmation: new_password
    UsersMailer.new_password_mail(new_password, self).deliver_now
  end

  # Attemps to match alumnus with a user account by alumni mail address
  # Receives row of a CSV file with the alumnus' data
  # If successful, the following fields are updated: 'alumnimail', 'emailverteiler', 'letztes_unternehmen', 'aktuelle_position'
  # If not, row is returned unchanged
  #
  # CSV file headers:
  # 0: nachname, 1: vorname, 2: akad_titel, 3: geburtsname, 4: abschluss, 5: jahr, 6: private_email, 7: alumnimail, 8: weitere_emailadresse, 9: emailverteiler, 10: keine_email, 11: letztes_unternehmen, 12: aktuelle_position, 13: ort_land, 14: auf_linkedin, 15: unternehmen_bekannt, 16: strae, 17: ort, 18: plz, 19: land, 20: telefon, 21: weitere_email__nicht_fr_newsletter_nutzen, 22: notiz, 23: einverstndnis_alumniarbeit_erteilt, 24: strae_weitere_adresse, 25: plz, 26: stadt, 27: land

  def self.update_alumni_data(row)
    matched_user = User.find_by_csv_row(row)

    if matched_user
      if not row[:alumnimail]
        # Kann es sein, dass ein gefundener User gar keine Alumni-Mailadresse hat?
        # Dann geht hier was verloren
        row[:alumnimail] = "#{matched_user.alumni_email}@hpi-alumni.de"
        row[:emailverteiler].gsub!(row[:private_email], row[:alumnimail])
      end

      if row[:private_email]
        if not (row[:emailverteiler].include?(matched_user.email) || row[:private_email] == matched_user.email)
          row[:emailverteiler].concat("#{matched_user.email};")
          row[:weitere_emailadresse] == nil ? row[:weitere_emailadresse] = matched_user.email : row[:weitere_emailadresse].concat(";#{matched_user.email}")
        end
      else
        row[:private_email] = matched_user.email
      end

      row[:keine_email] = nil if row[:keine_email]

      current_work = matched_user.manifestation.get_current_enterprises_and_positions
      row[:letztes_unternehmen] = current_work[0]
      row[:aktuelle_position] = current_work[1]
    end

    return row
  end

  # Finds user by alumni mail address taken from alumni mail address row field or extracted from other HPI domain email addresses (in that order)

  def self.find_by_csv_row(row)
    if row[:alumnimail]
      matched_user = User.where('LOWER(alumni_email) LIKE ?', row[:alumnimail].gsub('@hpi-alumni.de', '').downcase).first
    else
      row[:emailverteiler].split(';').each do |mail_address|
        hpi_domain_found = mail_address.gsub!(/@student.hpi.uni-potsdam.de|@student.hpi.de/, '')
        @extracted_hpi_address = mail_address if hpi_domain_found
      end

      matched_user = User.where('LOWER(alumni_email) LIKE ?', @extracted_hpi_address.downcase).first if @extracted_hpi_address
      #
      # matched_user = User.where('LOWER(alumni_email) LIKE ?', (row[:vorname]+"."+row[:nachname]).downcase).first if not matched_user
    end

    return matched_user
  end
end
