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

FactoryBot.define do
  factory :cv_job do
    association   :student
    position      'Ruby on Rails developer'
    employer      'SAP AG'
    description   'Developing a career portal'
    start_date    Date.current - 100
    end_date      Date.current - 10
    current       false
  end
end
