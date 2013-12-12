# == Schema Information
#
# Table name: student_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class StudentStatus < ActiveRecord::Base
	has_many :students
end
