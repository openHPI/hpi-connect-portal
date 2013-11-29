FactoryGirl.define do
  factory :user do
    sequence(:firstname)  { |n| "User #{n}" }
    sequence(:lastname)  { |n| "the #{n} of his kind" }
    sequence(:email) { |n| "user_#{n}@example.com" } 
    sequence(:identity_url) { |n| "openid.example.com/users/user_#{n}" }
  end
end