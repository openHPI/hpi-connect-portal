# == Schema Information
#
# Table name: languages_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  language_id :integer
#  skill       :integer
#

FactoryGirl.define do
  factory :languages_user do
    association :user
    association :language
    skill 1
  end
end
