# == Schema Information
#
# Table name: programming_languages_students
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  programming_language_id :integer
#  skill                   :integer
#

class ProgrammingLanguagesStudent < ActiveRecord::Base
	belongs_to :student
  belongs_to :programming_language
end
