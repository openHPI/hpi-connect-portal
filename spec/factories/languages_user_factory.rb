# == Schema Information
#
# Table name: languages_users
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  language_id :integer
#  skill       :integer
#

FactoryBot.define do
  factory :languages_user do
    association :student
    association :language
    skill 1
  end
end
