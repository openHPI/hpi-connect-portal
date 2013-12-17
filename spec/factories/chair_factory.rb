# == Schema Information
#
# Table name: chairs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head_of_chair       :string(255)      not null
#  deputy_id           :integer
#

FactoryGirl.define do
  factory :chair do
    name "Awesome Chair"
    head_of_chair "Mr. Boss"
    description "Makes beautiful websites"
    association :deputy, factory: :user
  end
end
