require "spec_helper"

describe JobOffersMailer do
	include EmailSpec::Helpers
  	include EmailSpec::Matchers
	
	before(:each) do	
		@job_offer = FactoryGirl.create(:joboffer)
		@job_offer.chair.deputy = FactoryGirl.create(:user)
		@email = JobOffersMailer.new_job_offer_email(@job_offer)
	end

	describe "new job offer" do
		it "should include the link to the job offer" do
			@email.should have_body_text(/#{url_for(job_offer_path(@job_offer))}/)
			#mail.body.encoded.should match(url_for(job_offer_path(@job_offer)))
		end
	end  
end
