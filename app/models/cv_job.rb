# == Schema Information
#
# Table name: cv_jobs
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  position    :string(255)
#  employer    :string(255)
#  from        :date
#  to          :date
#  current     :boolean          default(FALSE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class CvJob < ActiveRecord::Base
  default_scope { order 'to desc, from desc' }
end
