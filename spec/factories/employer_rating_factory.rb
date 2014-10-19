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

FactoryGirl.define do
	factory :employer_rating do
		association :student
		association :employer
	end
end
