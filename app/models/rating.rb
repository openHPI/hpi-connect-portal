# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  employer_id  :integer
#  job_offer_id :integer
#  score        :integer
#  headline     :text
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :student
  belongs_to :employer
  belongs_to :job_offer
  
  validates :student, :employer, :score, :headline, :description, presence: true
  validates :score, inclusion: { in: 1..5 }
  
end