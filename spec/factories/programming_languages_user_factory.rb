# == Schema Information
#
# Table name: programming_languages_users
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  programming_language_id :integer
#  skill                   :integer
#

FactoryGirl.define do
  factory :programming_languages_user do
    association :user
    association :programming_language
    skill 1
  end
end
