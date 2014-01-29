FactoryGirl.define do
  factory :programming_languages_newsletter_information do
    association :user, :student
    association :programming_language
  end
end