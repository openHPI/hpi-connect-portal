FactoryGirl.define do
  factory :chair do
    name "Awesome Chair"
    head_of_chair "Mr. Boss"
    description "Makes beautiful websites"
    association :deputy, factory: :user
  end
end