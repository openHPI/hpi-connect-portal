require "rails_helper"

describe JobOffersMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @staff = FactoryBot.create(:staff)
    @staff2 = FactoryBot.create(:staff)
    @job_offer = FactoryBot.create(:job_offer)
    @job_offer2 = FactoryBot.create(:job_offer)
    @staff2.update(employer: @job_offer2.employer)
    @job_offers = [@job_offer, @job_offer2]
    @job_offer.reload
    @job_offer2.reload
    ActionMailer::Base.deliveries = []
  end

  describe "new job offer" do
    before(:each) do
      @email = JobOffersMailer.new_job_offer_email(@job_offer).deliver_now
    end

    it "should include the link to the job offer" do
      expect(@email).to have_body_text(url_for(controller:"job_offers", action: "show", id: @job_offer.id, only_path: false))
    end

    it "should include the job title int the subject" do
      expect(@email.subject).to have_content(@job_offer.title)
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should be send to the admin" do
      expect(@email.to).to eq([Configurable.mailToAdministration])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "job offer prolonged" do
    before(:each) do
      @email = JobOffersMailer.job_prolonged_email(@job_offer).deliver_now
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should have be send to the staff members" do
      expect(@email.to).to eq(@job_offer.employer.staff_members.collect(&:email))
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "admin accepted application" do
    before(:each) do
      @email = JobOffersMailer.admin_accepted_job_offer_email(@job_offer.reload, @job_offer.employer.staff_members[0]).deliver_now
    end

    it "should send an email to staff member" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(@email.to).to eq([@job_offer.employer.staff_members[0].email])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end

  end

  describe "admin declined application" do
    before(:each) do
      @email = JobOffersMailer.admin_declined_job_offer_email(@job_offer.reload, @job_offer.employer.staff_members[0]).deliver_now
    end

    it "should send an email to staff" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(@email.to).to eq([@job_offer.employer.staff_members[0].email])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "responsible user closed job" do
    before(:each) do
      @email = JobOffersMailer.job_closed_email(@job_offer).deliver_now
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should have be send to the default staff address" do
      expect(@email.to).to eq([Configurable.mailToAdministration])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "will expire" do
    before(:each) do
      @email = JobOffersMailer.job_will_expire_email(@job_offer).deliver_now
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(@job_offer.employer.staff_members.size)
    end

  end
end
