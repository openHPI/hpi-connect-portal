class JobOffer < ActiveRecord::Base

	def self.sort(order_attribute) 
		order(order_attribute)
	end

end
