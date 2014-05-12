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

  def self.student_level
    return 1
  end

  def self.staff_level
    return 2
  end

  def self.admin_level
    return 3
  end

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
