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

require 'spec_helper'

describe CvJob do
  pending "add some examples to (or delete) #{__FILE__}"
end
