# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Language < ApplicationRecord
  has_many :languages_users
  has_many :users, through: :languages_users

  validates_uniqueness_of :name
end
