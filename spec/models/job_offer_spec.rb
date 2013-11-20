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

require 'spec_helper'

describe JobOffer do
	it "does not create a joboffer if attributes are not set" do
		assert !JobOffer.create.valid?
	end

	it "does create a joboffer if all required attributes are set" do
		assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", 
			start_date: Date.new(2013,11,1), compensation: 10.5, time_effort: 9).valid?
	end

	it "does not create a joboffer if start_date is after end_date" do
		assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", 
			chair:"Epic", start_date: Date.new(2013,11,1), end_date: Date.new(2013,10,1), compensation: 10.5, time_effort: 9).valid?
	end

	it "does create a joboffer if end_date is after start_date" do
		assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", 
			start_date: Date.new(2013,11,1), end_date: Date.new(2013,12,1), compensation: 10.5, time_effort: 9).valid?
	end

	it "returns job offers sorted by start_date" do
		    
		FactoryGirl.create(:joboffer, start_date: Date.new(2013,2,1), end_date: Date.new(2013,3,1))
		FactoryGirl.create(:joboffer, start_date: Date.new(2013,10,1), end_date: Date.new(2013,11,2))
		FactoryGirl.create(:joboffer, start_date: Date.new(2013,1,1), end_date: Date.new(2013,5,1))
		FactoryGirl.create(:joboffer, start_date: Date.new(2013,7,1), end_date: Date.new(2013,8,1))
		FactoryGirl.create(:joboffer, start_date: Date.new(2013,4,1), end_date: Date.new(2013,5,1))

		sorted_job_offers = JobOffer.sort "date"
		(sorted_job_offers).each_with_index do |offer, index|

			 if sorted_job_offers.length == (index + 1)	
			 	break
			 end
			offer.start_date.should <= sorted_job_offers[index+1].start_date
		end
	end

	it "returns job offers sorted by their chair" do
		    
		FactoryGirl.create(:joboffer, chair: "Internet Technologies")
		FactoryGirl.create(:joboffer, chair: "EPIC")
		FactoryGirl.create(:joboffer, chair: "Software Architecture")
		FactoryGirl.create(:joboffer, chair: "Information Systems")
		FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

		sorted_job_offers = JobOffer.sort "chair"
		(sorted_job_offers).each_with_index do |offer, index|

			 if sorted_job_offers.length == (index + 1)	
			 	break
			 end
			offer.chair.should <= sorted_job_offers[index+1].chair
		end
	end

	it "returns job offers filtered by chair EPIC" do
		    
		FactoryGirl.create(:joboffer, chair: "EPIC")
		FactoryGirl.create(:joboffer, chair: "EPIC")
		FactoryGirl.create(:joboffer, chair: "Software Architecture")
		FactoryGirl.create(:joboffer, chair: "Information Systems")
		FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

		filtered_job_offers = JobOffer.filter(chair: "EPIC")
		assert_equal(filtered_job_offers.length, 2);
	end
end


