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
  validate :email, presence: true
  validate :alumni_email, presence: true
  validate :token, presence: true, uniqueness: { case_sensitive: true }

  def self.create_from_row(row)
    alumni = Alumni.new firstname: row[:firstname], lastname: row[:lastname], email: row[:email] alumni_email: row[:alumni_email]
    alumni.generate_unique_token
    if alumni.save
      AlumniMailer.creation_email(alumni).deliver
      return :created
    end
    return alumni
  end

  def generate_unique_token
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 while Alumni.exists? token: code
    update_column :token, code
  end

  def link(user)
    user.update_column :alumni_email, alumni_email
    self.destroy
  end
end
