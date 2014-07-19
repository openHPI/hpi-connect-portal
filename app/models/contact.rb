# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  c_name           :string(255)
#  c_street         :string(255)
#  c_zip_city       :string(255)
#  c_email          :string(255)
#  c_phone          :string(255)
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
