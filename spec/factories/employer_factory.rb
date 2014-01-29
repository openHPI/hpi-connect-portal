# == Schema Information
#
# Table name: employers
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
#  head                :string(255)      not null
#  deputy_id           :integer
#  external            :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :employer do
    sequence(:name) { |n| "Employer #{n}" }
    head            "Mr. Boss"
    description     "Makes beautiful websites"

    before(:create) do | employer |
      employer.deputy = FactoryGirl.create(:user, :staff, employer: employer)
    end
  end
end
