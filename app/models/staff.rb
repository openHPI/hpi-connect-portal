# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Staff < ActiveRecord::Base

  has_one :user, as: :manifestation, dependent: :destroy
  belongs_to :employer

  delegate :firstname, :lastname, :full_name, :email, to: :user

  validates :employer, presence: true

  def deputy?
    employer && Employer.exists?(deputy: self)
  end
end
