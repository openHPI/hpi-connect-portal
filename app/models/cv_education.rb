# == Schema Information
#
# Table name: cv_educations
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  degree      :string(255)
#  institution :string(255)
#  from        :date
#  to          :date
#  current     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class CvEducation < ActiveRecord::Base
  default_scope { order 'to desc, from desc' }
end
