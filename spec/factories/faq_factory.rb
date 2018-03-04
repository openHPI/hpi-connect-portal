# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  answer     :text
#  created_at :datetime
#  updated_at :datetime
#  locale     :string(255)
#

FactoryBot.define do
  factory :faq do
    sequence(:question)  { |n| "Question #{n}" }
    sequence(:answer)  { |n| "Answer #{n}" }
    locale "en"
  end
end
