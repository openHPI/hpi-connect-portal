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
#  assigned_student_id :integer
#  flexible_start_date :boolean          default(FALSE)
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
    association       :responsible_user, factory: :user

    before(:create) do |job_offer, evaluator|
      job_offer.employer ||= FactoryGirl.create(:employer)
      job_offer.responsible_user = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :staff), employer: job_offer.employer)
    end
  end
end
