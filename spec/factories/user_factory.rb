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
#

FactoryGirl.define do
  factory :user do
    sequence(:firstname)    { |n| "User #{n}" }
    sequence(:lastname)     { |n| "the #{n}th of his kind" }
    sequence(:email)        { |n| "user_#{n}@example.com" }
    password                "password123"
    password_confirmation   "password123"

    trait :admin do
      admin true
    end
  end
end
