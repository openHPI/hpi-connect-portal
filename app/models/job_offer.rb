class JobOffer < ActiveRecord::Base
	has_and_belongs_to_many :programming_languages
	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
	validates_datetime :end_date, :on_or_after => :start_date, :allow_blank => :end_date


	def self.sort(order_attribute) 
		if order_attribute == "date"
			order(:start_date)
		elsif order_attribute == "chair"
			order(:chair)
		end
	end

	def self.search(search_attribute)
		search_string = "%" + search_attribute + "%"
		find(:all, :conditions => ['title LIKE ? OR description LIKE ? OR chair LIKE ?', search_string, search_string, search_string])
	end

end
