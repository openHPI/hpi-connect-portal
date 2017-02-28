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
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

FactoryGirl.define do
  factory :user do
    sequence(:firstname)    { |n| "Firstname#{n}" }
    sequence(:lastname)     { |n| "Lastname#{n}" }
    sequence(:email)        { |n| "user_#{n}@example.com" }
    password                "password123"
    password_confirmation   "password123"
    activated               true

    trait :admin do
      admin true
    end

    trait :alumnus do
      manifestation           factory: :student
      sequence(:alumni_email) { |n| "Firstname#{n}.Lastname#{n}" }
    end

    trait :student do
      manifestation factory: :student
    end

    trait :staff do
      manifestation factory: :staff
    end
  end
end
