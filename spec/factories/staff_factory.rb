# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryBot.define do
  factory :staff do
    association :user
    association :employer

    trait :of_premium_employer do
      association :employer, :premium
    end
  end
end
