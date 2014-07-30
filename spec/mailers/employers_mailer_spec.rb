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
end
