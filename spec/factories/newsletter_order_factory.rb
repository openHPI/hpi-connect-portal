# == Schema Information
#
# Table name: newsletter_orders
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  search_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :newsletter_order do
    association   :student
    search_params   {  {  state: 3  }  }

    before(:create) do |newsletter_order|
      newsletter_order.student = FactoryGirl.create(:student) if newsletter_order.student.nil?
    end
  end
end
