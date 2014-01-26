FactoryGirl.define do
  factory :employers_newsletter_information do
    association :user, :student
    association :employer
  end
end