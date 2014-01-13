FactoryGirl.define do
  factory :languages_user do
    association :user
    association :language
    skill 1
  end
end