# == Schema Information
#
# Table name: employers_newsletter_informations
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  employer_id :integer
#

FactoryGirl.define do
  factory :employers_newsletter_information do
    association :user, :student
    association :employer
  end
end
