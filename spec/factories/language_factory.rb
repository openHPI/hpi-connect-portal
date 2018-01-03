# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryBot.define do
  factory :language do
    sequence(:name)  { |n| "Language #{n}" }
  end
end
