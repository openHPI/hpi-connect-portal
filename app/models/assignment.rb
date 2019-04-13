# == Schema Information
#
# Table name: assignments
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  job_offer_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Assignment < ApplicationRecord

  belongs_to :student
  belongs_to :job_offer
end
