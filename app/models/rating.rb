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

class Rating < ApplicationRecord
  belongs_to :student
  belongs_to :employer
  belongs_to :job_offer

  validates :student, :employer, :headline, :description, :score_overall, presence: true
  validates :score_overall, inclusion: { in: 1..5 }
  validates :score_atmosphere, :score_salary, :score_work_life_balance, :score_work_contents, inclusion: { in: 1..5 }, allow_blank: true, allow_nil: true

  self.per_page = 15

end
