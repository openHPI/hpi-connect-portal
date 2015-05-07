require "spec_helper"

describe EmployersMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @employer = FactoryGirl.create(:employer)
    ActionMailer::Base.deliveries = []
    FactoryGirl.create(:staff, employer: @employer)
    @employer.reload
  end

  describe "new employer" do

    before(:each) do
      @email = EmployersMailer.new_employer_email(@employer).deliver
    end

    it "should include the link to the employer" do
      @email.should have_body_text(url_for(controller:"employers", action: "show", id: @employer.id, only_path: false))
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should be send to the administration" do
      @email.to.should eq([Configurable.mailToAdministration])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      @email.from.should eq(['noreply-connect@hpi.de'])
    end
  end

  describe "registration confirmation" do
    
    before(:each) do
      @email = EmployersMailer.registration_confirmation(@employer)
    end

    it "should send email to both staff_members" do
      ActionMailer::Base.deliveries.count.should == @employer.staff_members.size
    end

    it "should contain the subject" do
      @email.subject.should have_content("Your registration on HPI Connect")
    end

  end

  describe "invite_colleague" do

    before(:each) do
      @colleague_email = "tester@test.de"
      @receiver_name = "Top Receiver"
      @sender = FactoryGirl.create(:user)
      @email = EmployersMailer.invite_colleague_email(@employer, @colleague_email, @receiver_name, @sender)
    end

    it "should send mail to colleague email" do
      @email.to.should include(@colleague_email)
    end

    it "should contain the subject" do
      @email.subject.should have_content(I18n.t("employers_mailer.invite_colleague.subject"))
    end

    it "should contain employer token" do
      @email.should have_body_text(@employer.token)
    end

    it "should contain receiver_name" do
      @email.should have_body_text @receiver_name
    end

    it "should contain sender_name" do
      @email.should have_body_text @sender.full_name
    end

    it "should send copy to sender" do
      @email.bcc.should include(@sender.email)
    end

    it "should mail to Admins" do
      @email.bcc.should include(Configurable[:mailToAdministration])
    end

    it "does not contain sender_name if admin" do
      @sender = FactoryGirl.create(:user, :admin)
      @email = EmployersMailer.invite_colleague_email(@employer, @colleague_email, @receiver_name, @sender)
      @email.should_not have_body_text(@sender.full_name)
    end
  end
end
