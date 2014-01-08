# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  identity_url           :string(255)
#  lastname               :string(255)
#  firstname              :string(255)
#  role_id                :integer          default(1), not null
#  chair_id               :integer
#  semester               :integer
#  academic_program       :string(255)
#  birthday               :date
#  education              :text
#  additional_information :text
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  photo_file_name        :date
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :date
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :date
#  status                 :integer
#  user_status_id         :integer
#

FactoryGirl.define do
  factory :user do
    sequence(:firstname)  { |n| "User #{n}" }
    sequence(:lastname)  { |n| "the #{n}th of his kind" }
    sequence(:email) { |n| "user_#{n}@example.com" } 
    sequence(:identity_url) { |n| "openid.example.com/users/user_#{n}" }
    association :role
    semester 1
    academic_program 'Master'
    birthday '1970-12-10'
    education'Abitur'
    additional_information 'No'
    homepage 'oracle.com'
    github 'www.github.com/dieter'
    facebook 'www.faceboook.com/dieter'
    xing 'www.xing.com/dieter'
    linkedin'www.linkedin.com/dieter'
    status UserStatus.where(:name => 'employed (ext)').first

    after(:create) do |user, evaluator|
        create_list(:language, 1)
        create_list(:programming_language, 1)
    end
  end
end
