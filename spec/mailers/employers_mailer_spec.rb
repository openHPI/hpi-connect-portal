require "spec_helper"

describe EmployersMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @employer = FactoryGirl.create(:employer)
    ActionMailer::Base.deliveries = []
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

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq([Configurable.mailToAdministration])
    end
  end
end
