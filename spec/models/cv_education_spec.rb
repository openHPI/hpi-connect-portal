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

require 'spec_helper'

describe CvEducation do
  pending "add some examples to (or delete) #{__FILE__}"
end
