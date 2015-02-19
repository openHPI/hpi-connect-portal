# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  employer_id  :integer
#  job_offer_id :integer
#  score        :integer
#  headline     :text
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :rating do
    
    description   'Rating description'
    headline      'Rating headline'
    score         5
    employer
    student
    
  end
end
