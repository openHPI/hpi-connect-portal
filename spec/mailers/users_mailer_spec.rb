require "email_spec_helper"

describe UsersMailer do
  include EmailSpec::Helpers
    include EmailSpec::Matchers

    include ActionDispatch::TestProcess

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = FactoryGirl.create :user
  end



  describe "student forgot password" do
    before(:each) do
      @email = UsersMailer.new_password_mail('123ABCdef-_', @user).deliver  
    end

    it "should send one email to student" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have been sent to the student" do
      @email.to.should eq([@user.email])
    end

    it "should be sent from 'noreply-connect@hpi.de'" do
      @email.from.should eq(['noreply-connect@hpi.de'])
    end

    it "should have the new password in the body" do
      @email.body.should have_content('123ABCdef-_')
    end

  end
end