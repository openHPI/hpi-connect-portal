require "spec_helper"

describe JobOffersMailer do
    include EmailSpec::Helpers
    include EmailSpec::Matchers
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @job_offer = FactoryGirl.create(:job_offer, responsible_user: @user, assigned_students: [FactoryGirl.create(:user, :student)])
    @job_offer.employer.deputy = FactoryGirl.create(:user)
    @job_offer2 = FactoryGirl.create(:job_offer, responsible_user: @user2, assigned_students: [FactoryGirl.create(:user, :student)])
    @job_offer2.employer.deputy = @user2
    @job_offers = [@job_offer, @job_offer2]
    ActionMailer::Base.deliveries = []
  end

  describe "new job offer" do
    before(:each) do
      @email = JobOffersMailer.new_job_offer_email(@job_offer).deliver
      end

    it "should include the link to the job offer" do
      @email.should have_body_text(url_for(controller:"job_offers", action: "show", id: @job_offer.id, only_path: false))
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should be send to the deputy" do
      @email.to.should eq([@job_offer.employer.deputy.email])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq([Configurable.mailToAdministration])
    end
  end

  describe "job offer prolonged" do
    before(:each) do
      @email = JobOffersMailer.job_prolonged_email(@job_offer).deliver
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have be send to the administration" do
      @email.to.should eq([Configurable[:mailToAdministration]])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq(['hpi.hiwi.portal@gmail.com'])
    end
  end

  describe "deputy accepted application" do
    before(:each) do
      @email = JobOffersMailer.deputy_accepted_job_offer_email(@job_offer).deliver
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have be send to the responsible WiMi" do
      @email.to.should eq([@job_offer.responsible_user.email])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq(['hpi.hiwi.portal@gmail.com'])
    end

    it "should have the title of the joboffer in the subject" do
      @email.subject.should have_content(@job_offer.title)
    end
  end

  describe "deputy declined application" do
    before(:each) do
      @email = JobOffersMailer.deputy_declined_job_offer_email(@job_offer).deliver
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have be send to the responsible WiMi" do
      @email.to.should eq([@job_offer.responsible_user.email])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq(['hpi.hiwi.portal@gmail.com'])
    end

    it "should have the title of the joboffer in the subject" do
      @email.subject.should have_content(@job_offer.title)
    end
  end

  describe "responsible user closed job" do
    before(:each) do
      @email = JobOffersMailer.job_closed_email(@job_offer).deliver
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have be send to the default staff address" do
      @email.to.should eq([Configurable.mailToAdministration])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq([Configurable.mailToAdministration])
    end
  end

  describe "responsible user accepted student" do
    before(:each) do
      @email = JobOffersMailer.job_student_accepted_email(@job_offer).deliver
    end

    it "should send an email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should have be send to the default staff address" do
      @email.to.should eq([Configurable.mailToAdministration])
    end

    it "should be send from 'hpi.hiwi.portal@gmail.com'" do
      @email.from.should eq(['hpi.hiwi.portal@gmail.com'])
    end

    it "should have job information in its body" do
      @email.body.should have_content(@job_offer.title)
    end
  end
    describe "students are informed about new job offer" do
      before(:each) do
        @email = JobOffersMailer.new_job_offer_info_email(@job_offer, @job_offer.assigned_students.last).deliver
      end

      it "should send an email" do
        ActionMailer::Base.deliveries.count.should == 1
      end

      it "should have be send to user adress" do
        @email.to.should eq([@job_offer.assigned_students.last.email])
      end

      it "should be send from 'hpi.hiwi.portal@gmail.com'" do
        @email.from.should eq(['hpi.hiwi.portal@gmail.com'])
      end

      it "should have job information in its body" do
        @email.body.should have_content(@job_offer.title)
      end
    end
end
