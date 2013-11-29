FactoryGirl.define do
  factory :job_offer do
    sequence(:title)  { |n| "A newt title #{n}" }
    description "Some really cool description text."
  end
end