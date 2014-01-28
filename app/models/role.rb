# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  level      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base

	def student_role?
		name == 'Student'
	end

	def staff_role?
		name == 'Staff'
	end

	def admin_role?
		name == 'Admin'
	end
end
