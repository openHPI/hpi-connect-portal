FactoryGirl.define do
  factory :programming_languages_user do
    association :user
    association :programming_language
    skill 1
  end
end