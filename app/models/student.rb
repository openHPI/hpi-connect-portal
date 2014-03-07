# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  employment_status      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Student < ActiveRecord::Base

  has_one :user, as: :manifestation, dependent: :destroy

  has_many :applications
  has_many :job_offers, through: :applications
  has_many :programming_languages_users
  has_many :programming_languages, through: :programming_languages_users
  has_many :languages_users
  has_many :languages, through: :languages_users
  has_many :possible_employers, through: :employers_newsletter_information
  has_many :possible_programming_language, through: :programming_languages_newsletter_information
  has_and_belongs_to_many :assigned_job_offers, class_name: "JobOffer"

  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :programming_languages

  validates :semester, :academic_program, :education, presence: true
  validates_inclusion_of :semester, :in => 1..12
end
