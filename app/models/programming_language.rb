# == Schema Information
#
# Table name: programming_languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProgrammingLanguage < ActiveRecord::Base
  has_many :programming_languages_users
  has_many :students, through: :programming_languages_users

  has_and_belongs_to_many :job_offer
  validates_uniqueness_of :name
end
