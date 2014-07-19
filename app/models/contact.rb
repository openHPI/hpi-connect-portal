# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  employer_id  :integer
#  job_offer_id :integer
#  name         :string(255)
#  street       :string(255)
#  zip_city     :string(255)
#  email        :string(255)
#  phone        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Contact < ActiveRecord::Base
	belongs_to :employer
	belongs_to :job_offer
	

	def contact_is_empty?
    	self.merged_contact.length == 0
  	end

  	def merged_contact
    	contact = ""
    	[name, street, zip_city, email, phone].map{ |entry| (entry!=nil) ? contact += "#{entry}\n" : nil}
    	contact
 	end
end
