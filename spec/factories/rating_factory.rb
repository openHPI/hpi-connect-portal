# == Schema Information
#
# Table name: ratings
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  employer_id             :integer
#  job_offer_id            :integer
#  headline                :string(255)
#  description             :text
#  score_overall           :integer
#  score_atmosphere        :integer
#  score_salary            :integer
#  score_work_life_balance :integer
#  score_work_contents     :integer
#

FactoryGirl.define do
  factory :rating do
    description             'Rating description'
    headline                'Rating headline'
    score_overall           5
    score_atmosphere        4
    score_salary            3
    score_work_life_balance 2
    score_work_contents     1
    employer
    student
  end
end
