FactoryGirl.define do
  factory :language do
    sequence(:name)  { |n| "Language #{n}" }
  end
end