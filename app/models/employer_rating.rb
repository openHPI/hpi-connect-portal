# == Schema Information
#
# Table name: employer_ratings
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  employer_id :integer
#  rating      :integer
#  recension   :text
#

class EmployerRating < ActiveRecord::Base
	belongs_to :employer
	belongs_to :student
end
