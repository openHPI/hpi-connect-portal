# == Schema Information
#
# Table name: programming_languages_newsletter_informations
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  programming_language_id :integer
#

class ProgrammingLanguagesNewsletterInformation < ActiveRecord::Base
	belongs_to :programming_language
	belongs_to :student
end
