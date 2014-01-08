FactoryGirl.define do
  factory :programming_language do
    sequence(:name)  { |n| "Programming language #{n}" }
  end
end