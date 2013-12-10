# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  is_student          :boolean
#  lastname            :string(255)
#  firstname           :string(255)
#  role_id             :integer          default(1), not null
#  chair_id            :integer
#

FactoryGirl.define do
  factory :user do
    sequence(:firstname)  { |n| "User #{n}" }
    sequence(:lastname)  { |n| "the #{n} of his kind" }
    sequence(:email) { |n| "user_#{n}@example.com" } 
    sequence(:identity_url) { |n| "openid.example.com/users/user_#{n}" }
    semester 1
    academic_program 'Master'
    birthday '1970-12-10'
    education'Abitur'
    additional_information 'No'
    homepage 'www.dieter.de'
    github 'www.github.com/dieter'
    facebook 'www.faceboook.com/dieter'
    xing 'www.xing.com/dieter'
    linkedin'www.linkedin.com/dieter'
    languages Language.where(:name => 'Englisch')
    programming_languages ProgrammingLanguage.where(:name => ['Ruby'])
    user_status UserStatus.where(:name => 'employed (ext)').first
    role Role.where(:name => 'Student').first
    is_student true
  end
end
