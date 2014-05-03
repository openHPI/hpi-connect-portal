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
#  deputy_id           :integer
#  activated           :boolean          default(FALSE), not null
#  place_of_business   :string(255)
#  website             :string(255)
#  line_of_business    :string(255)
#  year_of_foundation  :integer
#  number_of_employees :string(255)
#  requested_package   :integer          default(0), not null
#  booked_package      :integer          default(0), not null
#

FactoryGirl.define do
  factory :employer do
    sequence(:name) { |n| "Employer #{n}" }
    description     "Makes beautiful websites"
    activated       true
    place_of_business "Berlin"
    website         "http://mrboss.de"
    line_of_business "IT"
    year_of_foundation 1991
    number_of_employees "50 - 100"

    before(:create) do | employer |
      employer.deputy = FactoryGirl.create(:staff, employer: employer)
    end
  end
end
