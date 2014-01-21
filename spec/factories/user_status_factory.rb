# == Schema Information
#
# Table name: user_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :user_status do
    sequence(:name)  { |n| "User status #{n}" }
  end
end
