# == Schema Information
#
# Table name: cv_educations
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  degree      :string(255)
#  field       :string(255)
#  institution :string(255)
#  start_date  :date
#  end_date    :date
#  current     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :cv_education do
    association   :student
    degree        'Bachelor of Science'
    field         'IT Systems Engineering'
    institution   'Hasso Plattner Institute'
    start_date    Date.current - 100
    end_date      Date.current - 10
    current       false
  end
end
