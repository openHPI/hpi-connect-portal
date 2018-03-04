# == Schema Information
#
# Table name: programming_languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  private    :boolean          default: false
#

class ProgrammingLanguage < ActiveRecord::Base
  has_many :programming_languages_users
  has_many :students, through: :programming_languages_users

  accepts_nested_attributes_for :programming_languages_users

  has_and_belongs_to_many :job_offer

  scope :selectable_for_student, ->(student) { where.not(id: student.programming_languages.pluck(:id), private: true) }
end
