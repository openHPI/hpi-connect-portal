# == Schema Information
#
# Table name: cv_educations
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  degree      :string(255)
#  field       :string(255)
#  institution :string(255)
#  start_date  :date
#  end_date    :date
#  current     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class CvEducation < ApplicationRecord
  belongs_to :student

  default_scope { order 'current DESC, end_date DESC, start_date DESC' }

  validates :student, presence: true
  validates :degree, presence: true
  validates :field, presence: true
  validates :institution, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, unless: :current

  def self.too_blank?(attributes)
    attributes['degree'].blank? & attributes['field'].blank? & attributes['institution'].blank?
  end
end
