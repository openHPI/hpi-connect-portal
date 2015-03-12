# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#  visibility_id          :integer          default(0), not null
#  dschool_status_id      :integer          default(0), not null
#  group_id               :integer          default(0), not null
#

FactoryGirl.define do
  factory :student do
    semester            1
    academic_program_id Student::ACADEMIC_PROGRAMS.index("bachelor")
    birthday            '1970-12-10'
    graduation_id       Student::GRADUATIONS.index("abitur")
    visibility_id       2

    before(:create) do |student|
      student.user = FactoryGirl.create(:user, manifestation: student)
    end

    after(:create) do |user, evaluator|
      create_list(:language, 1)
      create_list(:programming_language, 1)
    end
  end
end
