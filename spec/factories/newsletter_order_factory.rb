FactoryGirl.define do
  factory :newsletter_order do
    association   :student
    search_params   {  {  state: 3  }  }

    before(:create) do |newsletter_order|
      newsletter_order.student = FactoryGirl.create(:student) if newsletter_order.student.nil?
    end
  end
end