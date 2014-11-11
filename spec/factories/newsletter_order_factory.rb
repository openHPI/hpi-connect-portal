FactoryGirl.define do
  factory :newsletter_order do
    association   :student
    search_params   {  {  state: 3  }  }
  end
end