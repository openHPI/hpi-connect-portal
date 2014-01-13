# == Schema Information
#
# Table name: job_offers
#
#  id                  :integer          not null, primary key
#  description         :text
#  title               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  time_effort         :float
#  compensation        :float
#  room_number         :string(255)
#  chair_id            :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  assigned_student_id :integer
#

FactoryGirl.define do
  factory :job_offer, class: JobOffer do
    sequence(:title)  { |n| "Awesome Job #{n}" }
    description  "Develop a website"
    start_date   Date.new(2013,1,1)
    end_date     Date.new(2013,2,1)
    compensation 10.5
    time_effort  9
    association :chair, factory: :chair
    association :status, factory: :job_status
    association :responsible_user, factory: :user
  end
end