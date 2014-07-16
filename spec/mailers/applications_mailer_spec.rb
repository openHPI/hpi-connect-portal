
require "email_spec_helper"

describe ApplicationsMailer do
	include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ActionDispatch::TestProcess

	before(:each) do
		ActionMailer::Base.delivery_method = :test
    	ActionMailer::Base.perform_deliveries = true
    	@staff = FactoryGirl.create :staff
    	@student = FactoryGirl.create :student
    	@staff.user.update_column :email, 'staff@example.com'
    	@student.user.update_column :email, 'student@example.com'
    	@job_offer = FactoryGirl.create :job_offer
    	@application = FactoryGirl.create :application, student: @student, job_offer: @job_offer

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

		it "should be send from 'noreply-connect@hpi.de'" do
			@email.from.should eq(['noreply-connect@hpi.de'])
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

		it "should be send from 'noreply-connect@hpi.de'" do
			@email.from.should eq(['noreply-connect@hpi.de'])
		end

		it "should have the title of the joboffer in the body" do
			@email.body.should have_content(@job_offer.title)
		end
	end

	describe "application created" do
		before(:each) do
			@test_file = ActionDispatch::Http::UploadedFile.new({
			  :filename => 'test_picture.jpg',
			  :type => 'image/jpeg',
			  :tempfile => fixture_file_upload('/images/test_picture.jpg')
			})

		  	@message = "Testmessage"
		  	@email = ApplicationsMailer.new_application_notification_email(@application, @message, false, {:file_attributes => [:file => @test_file] })

			html = get_message_part(@email, /html/)
			@html_body = html.body.raw_source
		end
		it "should send an email" do
			ActionMailer::Base.deliveries.count.should == 1
		end

		it "should have be send to the responsible wimi" do
			@job_offer.employer.staff_members.each { |staff|      		
			@email.to.should eq([staff.email]) }
		end

		it "should be send from 'noreply-connect@hpi.de'" do
			@email.from.should eq(['noreply-connect@hpi.de'])
		end

		it "should have the personal application message in the body" do
			@html_body.should have_content(@message)
		end

		it "should include all attached files the student chose" do
			@email.attachments.should have(1).attachment
			attachment = @email.attachments[0]
			attachment.should be_a_kind_of(Mail::Part)
			attachment.content_type.should be_start_with(@test_file.content_type)
			attachment.filename.should == @test_file.original_filename
		end
	end
end