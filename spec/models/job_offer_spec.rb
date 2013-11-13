require 'spec_helper'

describe JobOffer do
	it "does not create a joboffer if attributes are not set" do
		beforeCount = JobOffer.count
		JobOffer.create
		afterCount = JobOffer.count
		assert_equal(beforeCount, afterCount)
	end

	it "does create a joboffer if all required attributes are set" do
		beforeCount = JobOffer.count
		JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", start_date: Date.new(2013,11,1), compensation: 10.5, time_effort: 9)
		afterCount = JobOffer.count
		assert_equal(beforeCount+1, afterCount)
	end
end


