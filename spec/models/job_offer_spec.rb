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
end


