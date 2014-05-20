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
#  employer_id         :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  vacant_posts        :integer
#  flexible_start_date :boolean          default(FALSE)
#  category_id         :integer          default(0), not null
#  state_id            :integer          default(3), not null
#  graduation_id       :integer          default(2), not null
#  academic_program_id :integer
#  prolonged           :boolean          default(FALSE)
#  prolonged_at        :datetime
#

FactoryGirl.define do
  factory :job_offer, class: JobOffer do
    sequence(:title)  { |n| "Title #{n}" }
    description       "Develop a website"
    start_date        Date.current + 1
    end_date          Date.current + 2
    compensation      10.5
    time_effort       9
    association       :status, factory: :job_status
    association       :responsible_user, factory: :staff
    vacant_posts      1

    before(:create) do |job_offer, evaluator|
      job_offer.employer ||= FactoryGirl.create(:employer)
      job_offer.responsible_user = FactoryGirl.create(:staff, employer: job_offer.employer)
    end
  end
end
