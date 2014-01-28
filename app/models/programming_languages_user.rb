# == Schema Information
#
# Table name: programming_languages_users
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  programming_language_id :integer
#  skill                   :integer
#

class ProgrammingLanguagesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :programming_language
end
