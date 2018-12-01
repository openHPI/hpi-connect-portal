# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  name             :string(255)
#  street           :string(255)
#  zip_city         :string(255)
#  email            :string(255)
#  phone            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :contact do

    sequence(:name)         { |n| "Contact #{n}" }
    sequence(:street)       { |n| "Street #{n}" }
    sequence(:zip_city)     { |n| "City #{n}" }
    sequence(:email)        { |n| "contact_#{n}@example.com" }
    phone                   { "0815" }
  end
end
