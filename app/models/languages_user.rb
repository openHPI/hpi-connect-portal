# == Schema Information
#
# Table name: languages_users
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  language_id :integer
#  skill       :integer
#

class LanguagesUser < ApplicationRecord
  belongs_to :student
  belongs_to :language
end
