# == Schema Information
#
# Table name: employers
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head                :string(255)      not null
#  external            :boolean          default(FALSE)
#  activated           :boolean          default(FALSE), not null
#

class Employer < ActiveRecord::Base
  NUMBER_OF_EMPLOYEES_FIELDS = ["< 50", "50 - 100", "100 - 500", "500 - 1000", "> 1000"]
  has_attached_file :avatar, styles: { medium: "200x200" }, default_url: "/images/:style/missing.png"

  has_many :staff_members, class_name: 'Staff'
  has_many :job_offers
  has_many :interested_students, class_name: 'Student', through: :employers_newsletter_information

  accepts_nested_attributes_for :staff_members

  validates_attachment_size :avatar, less_than: 5.megabytes
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :number_of_employees, presence: true
  validates :place_of_business, presence: true
  validates :year_of_foundation, numericality: { only_integer: true, 
    greater_than: 1800, 
    less_than_or_equal_to: Time.now.year}

  scope :active, -> { where(activated: true) }
end
