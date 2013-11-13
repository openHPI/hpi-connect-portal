class JobOffer < ActiveRecord::Base
	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true

end
