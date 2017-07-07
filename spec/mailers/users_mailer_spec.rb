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
      @email = UsersMailer.new_password_mail('123ABCdef-_', @user).deliver_now
    end

    it "should send one email to student" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should have been sent to the student" do
      expect(@email.to).to eq([@user.email])
    end

    it "should be sent from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end

    it "should have the new password in the body" do
      expect(@email.body).to have_content('123ABCdef-_')
    end

  end
end
