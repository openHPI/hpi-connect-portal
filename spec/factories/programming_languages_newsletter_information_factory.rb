# == Schema Information
#
# Table name: programming_languages_newsletter_informations
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  programming_language_id :integer
#

FactoryGirl.define do
  factory :programming_languages_newsletter_information do
    association :user, :student
    association :programming_language
  end
end
