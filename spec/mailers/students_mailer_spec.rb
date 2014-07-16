require "spec_helper"

describe StudentsMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @student = FactoryGirl.create(:student)
    ActionMailer::Base.deliveries = []
  end

  describe "new student" do

    before(:each) do
      @email = StudentsMailer.new_student_email(@student).deliver
    end

    it "should include the link to the student" do
      @email.should have_body_text(url_for(controller:"students", action: "show", id: @student.id, only_path: false))
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
end
