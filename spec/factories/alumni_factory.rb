# == Schema Information
#
# Table name: alumnis
#
#  id           :integer          not null, primary key
#  firstname    :string(255)
#  lastname     :string(255)
#  email        :string(255)      not null
#  alumni_email :string(255)      not null
#  token        :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :alumni do
    sequence(:firstname)    { |n| "Firstname#{n}" }
    sequence(:lastname)     { |n| "Lastname#{n}" }
    sequence(:email)        { |n| "user_#{n}@example.com" }
    sequence(:alumni_email) { |n| "Firstname#{n}.Lastname#{n}" }
    sequence(:token)        { |n| SecureRandom.urlsafe_base64 + "#{n}" }
  end
end
