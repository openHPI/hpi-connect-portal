# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

FactoryBot.define do
  factory :job_offer, class: JobOffer do
    sequence(:title)  { |n| "Title #{n}" }
    description       "Develop a website"
    start_date        Date.current + 1
    end_date          Date.current + 2
    release_date      Date.current - 3
    compensation      10.5
    time_effort       9
    state_id          0
    association       :status, factory: :job_status
    student_group_id  {Student::GROUPS.index("hpi")}

    before(:create) do |job_offer, evaluator|
      job_offer.employer ||= FactoryBot.create(:employer)
      job_offer.contact = FactoryBot.create(:contact, counterpart: job_offer)
    end
  end
end
