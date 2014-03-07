# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  frequency          :integer          default(1), not null
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :user do
    sequence(:firstname)    { |n| "User #{n}" }
    sequence(:lastname)     { |n| "the #{n}th of his kind" }
    sequence(:email)        { |n| "user_#{n}@example.com" }
    sequence(:identity_url) { |n| "openid.example.com/users/user_#{n}" }
    association             :role
    semester                1
    academic_program        'Master'
    birthday                '1970-12-10'
    education               'Abitur'

    trait :student do
      association :role, :student
    end

    trait :staff do
      association :role, :staff
      association :employer
    end

    trait :admin do
      association :role, :admin
    end

    after(:create) do |user, evaluator|
      create_list(:language, 1)
      create_list(:programming_language, 1)
      user.status = UserStatus.where(:name => 'employedext').first || UserStatus.create(:name => 'employedext')
    end
  end
end
