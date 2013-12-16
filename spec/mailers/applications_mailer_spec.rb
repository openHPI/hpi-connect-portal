
require "spec_helper"

describe ApplicationsMailer do
	include EmailSpec::Helpers
  	include EmailSpec::Matchers
	before(:each) do
		ActionMailer::Base.delivery_method = :test
    	ActionMailer::Base.perform_deliveries = true
    	@student = FactoryGirl.create(:user, email:'test@example.com')
    	@job_offer = FactoryGirl.create(:job_offer, responsible_user: @student)
    	@application = FactoryGirl.create(:application, user: @student, job_offer: @job_offer)

		ActionMailer::Base.deliveries = []
	end


	describe "application accepted" do
		before(:each) do
			@email = ApplicationsMailer.application_accepted_student_email(@application).deliver
		end

		it "should send an email" do
			ActionMailer::Base.deliveries.count.should == 1
		end

		it "should have be send to the student" do
			@email.to.should eq([@student.email])
		end

		it "should be send from 'hpi-hiwi-portal@hpi.uni-potsdam.de'" do
			@email.from.should eq(['hpi-hiwi-portal@hpi.uni-potsdam.de'])
		end

		it "should have the title of the joboffer in the body" do
			@email.body.should have_content(@job_offer.title)
		end
	end
	describe "application declined" do
		before(:each) do
			@email = ApplicationsMailer.application_declined_student_email(@application).deliver
		end

		it "should send an email" do
			ActionMailer::Base.deliveries.count.should == 1
		end

		it "should have be send to the student" do
			@email.to.should eq([@student.email])
		end

		it "should be send from 'hpi-hiwi-portal@hpi.uni-potsdam.de'" do
			@email.from.should eq(['hpi-hiwi-portal@hpi.uni-potsdam.de'])
		end

		it "should have the title of the joboffer in the body" do
			@email.body.should have_content(@job_offer.title)
		end
	end
	after(:each) do
  		ActionMailer::Base.deliveries.clear
	end
end