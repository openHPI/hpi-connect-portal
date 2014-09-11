class Certificate < ActiveRecord::Base
	attr_accessor :student_id, :certificate_file
	
	belongs_to :student
	
	has_attached_file :certificate_file
	
  	validates_attachment_content_type :certificate_file, content_type: ['application/pdf']
end
