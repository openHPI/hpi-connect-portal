# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  name             :string(255)
#  street           :string(255)
#  zip_city         :string(255)
#  email            :string(255)
#  phone            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Contact < ActiveRecord::Base
	belongs_to :counterpart, polymorphic: true, touch: true	

	def contact_is_empty?
    	self.merged_contact.length == 0
  	end

  	def merged_contact
    	contact = ""
    	[contact_name, contact_street, contact_zip_city, contact_email, contact_phone].map{ |entry| (entry!=nil) ? contact += "#{entry}\n" : nil}
    	contact
 	end
end
