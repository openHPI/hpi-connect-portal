# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  job_offer_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :application do
    association :student
    association :job_offer, factory: :joboffer
  end
end
