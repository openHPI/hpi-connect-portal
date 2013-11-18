# == Schema Information
#
# Table name: job_offers
#
#  id          :integer          not null, primary key
#  description :string(255)
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class JobOffer < ActiveRecord::Base
	has_many :programming_languages
	accepts_nested_attributes_for :programming_languages
	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
	validates_datetime :end_date, :on_or_after => :start_date, :allow_blank => :end_date


	def self.sort(order_attribute) 
		if order_attribute == "date"
			order(:start_date)
		elsif order_attribute == "chair"
			order(:chair)
		end
	end

end
