# == Schema Information
#
# Table name: programming_languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :programming_language do
    sequence(:name)  { |n| "Programming language #{n}" }
  end
end
