# == Schema Information
#
# Table name: cv_jobs
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  position    :string(255)
#  employer    :string(255)
#  start_date  :date
#  end_date    :date
#  current     :boolean          default(FALSE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class CvJob < ActiveRecord::Base
  belongs_to :student
  
  default_scope { order 'current DESC, end_date DESC, start_date DESC' }

  validates :student, presence: true
  validates :position, presence: true
  validates :employer, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, unless: :current

  def self.too_blank?(attributes)
    attributes['position'].blank? && attributes['employer'].blank? && attributes['description'].blank?
  end
end
