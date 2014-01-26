FactoryGirl.define do
  factory :employers_newsletter_information do
    association :user_id, factory: :user
    employer_id FactoryGirl.create(:employer, name:"EPIC").id
  end
end