# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  level      :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryBot.define do
  factory :role do
    name 'Student'
    level 1

    trait :student do
      name 'Student'
      level 1
    end

    trait :staff do
      name 'Staff'
      level 2
    end

    trait :admin do
      name 'Admin'
      level 3
    end

    initialize_with { Role.where(name: name, level: level).first_or_create }
  end
end
