require "rails_helper"

describe EmployersMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @employer = FactoryBot.create(:employer)
    ActionMailer::Base.deliveries = []
    FactoryBot.create(:staff, employer: @employer)
    @employer.reload
  end

  describe "new employer" do

    before(:each) do
      @email = EmployersMailer.new_employer_email(@employer).deliver_now
    end

    it "should include the link to the employer" do
      expect(@email).to have_body_text(url_for(controller:"employers", action: "show", id: @employer.id, only_path: false))
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should be send to the administration" do
      expect(@email.to).to eq([Configurable.mailToAdministration])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "registration confirmation" do
    before(:each) do
      @email = EmployersMailer.registration_confirmation(@employer, @employer.staff_members[0]).deliver_now
    end

    it "should send email to staff member" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(@email.to).to eq([@employer.staff_members[0].email])
    end

    it "should contain the subject" do
      expect(@email.subject).to have_content("Your registration on HPI Connect")
    end

  end

  describe "invite_colleague" do

    before(:each) do
      @colleague_email = "tester@test.de"
      @receiver_name = "Top Receiver"
      @sender = FactoryBot.create(:user)
      @email = EmployersMailer.invite_colleague_email(@employer, @colleague_email, @receiver_name, @sender)
    end

    it "should send mail to colleague email" do
      expect(@email.to).to include(@colleague_email)
    end

    it "should contain the subject" do
      expect(@email.subject).to have_content(I18n.t("employers_mailer.invite_colleague.subject"))
    end

    it "should contain employer token" do
      expect(@email).to have_body_text(@employer.token)
    end

    it "should contain receiver_name" do
      expect(@email).to have_body_text @receiver_name
    end

    it "should contain sender_name" do
      expect(@email).to have_body_text @sender.full_name
    end

    it "should send copy to sender" do
      expect(@email.bcc).to include(@sender.email)
    end

    it "should mail to Admins" do
      expect(@email.bcc).to include(Configurable[:mailToAdministration])
    end

    it "does not contain sender_name if admin" do
      @sender = FactoryBot.create(:user, :admin)
      @email = EmployersMailer.invite_colleague_email(@employer, @colleague_email, @receiver_name, @sender)
      expect(@email).not_to have_body_text(@sender.full_name)
    end
  end
end
