FactoryGirl.define do
  factory :alumni do
    firstname               'Max'
    lastname                'Mustermann'
    sequence(:email)        { |n| "user_#{n}@example.com" }
    sequence(:alumni_email) { |n| "user_#{n}@alumni.com" }
    sequence(:token)        { |n| SecureRandom.urlsafe_base64 + "#{n}" }
  end
end
