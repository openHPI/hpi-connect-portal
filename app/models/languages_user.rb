# == Schema Information
#
# Table name: languages_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  language_id :integer
#  skill       :integer
#

class LanguagesUser < ActiveRecord::Base
  belongs_to :student
  belongs_to :language
end
