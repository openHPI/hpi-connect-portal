# == Schema Information
#
# Table name: languages_students
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  language_id :integer
#

class LanguagesStudent < ActiveRecord::Base
end
