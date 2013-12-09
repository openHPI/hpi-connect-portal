require "spec_helper"

describe JobOffersMailer do
	include EmailSpec::Helpers
  	include EmailSpec::Matchers
	
	before(:each) do
    	ActionMailer::Base.delivery_method = :test
    	ActionMailer::Base.perform_deliveries = true
    	ActionMailer::Base.deliveries = []
		@job_offer = FactoryGirl.create(:job_offer)
		@job_offer.chair.deputy = FactoryGirl.create(:user)
		@email = JobOffersMailer.new_job_offer_email(@job_offer).deliver
  	end

  	after(:each) do
  		ActionMailer::Base.deliveries.clear
	end


	describe "new job offer" do
		it "should include the link to the job offer" do
			@email.should have_body_text(url_for(controller:"job_offers", action: "show", id: @job_offer.id, only_path: false))
		end
		it "should send an email" do
			ActionMailer::Base.deliveries.count.should == 1
		end
	end  
end
