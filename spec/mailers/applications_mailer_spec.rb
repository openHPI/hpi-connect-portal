
require "email_spec_helper"

describe ApplicationsMailer do
	include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ActionDispatch::TestProcess

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

		it "should be send from 'hpi.hiwi.portal@gmail.com'" do
			@email.from.should eq(['hpi.hiwi.portal@gmail.com'])
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

		it "should be send from 'hpi.hiwi.portal@gmail.com'" do
			@email.from.should eq(['hpi.hiwi.portal@gmail.com'])
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
			@email = ApplicationsMailer.new_application_notification_email(@application, @message, false, {:file_attributes => [:file => @test_file] }).deliver
			
			html = get_message_part(@email, /html/)
			@html_body = html.body.raw_source
		end
		it "should send an email" do
			ActionMailer::Base.deliveries.count.should == 1
		end

		it "should have be send to the responsible wimi" do
			@email.to.should eq([@job_offer.responsible_user.email])
		end

		it "should be send from 'hpi.hiwi.portal@gmail.com'" do
			@email.from.should eq(['hpi.hiwi.portal@gmail.com'])
		end

		it "should have the title of the joboffer in the body" do
			@html_body.should have_content(@job_offer.title)
		end
		it "should have the name of the student in the body" do
			@html_body.should have_content(@student.firstname)
			@html_body.should have_content(@student.lastname)
		end
		it "should include the link to the students profile page" do
			@email.should have_body_text(url_for(controller:"students", action: "show", id: @student.id, only_path: false))
		end
		it "should have the personal application message in the body" do
			@html_body.should have_content(@message)
		end
		it "should include the students cv if activated" 

		it "should include all attached files the student chose" do
			@email.attachments.should have(1).attachment
			attachment = @email.attachments[0]
			attachment.should be_a_kind_of(Mail::Part)
			attachment.content_type.should be_start_with(@test_file.content_type)
			attachment.filename.should == @test_file.original_filename
		end
	end
end