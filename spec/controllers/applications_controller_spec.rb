require 'spec_helper'

describe ApplicationsController do

  let(:employer) { FactoryGirl.create(:employer) }
  let(:responsible_user) {  FactoryGirl.create(:user, employer: employer, role: staff_role)}
	let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :name => "open"), "responsible_user_id" => responsible_user.id} }
  before(:each) do
    @student = FactoryGirl.create(:student)
    @student.user.email = 'test@example.com'
    @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: "open"))
  end

  describe "GET decline" do
    before do
      @application = FactoryGirl.create(:application, student: @student, job_offer: @job_offer)
    end

    describe "having sufficient permissions" do

      before(:each) do
        sign_in @job_offer.responsible_user
      end

      it "deletes application" do
        
        expect{
          get :decline, {id: @application.id}
        }.to change(Application, :count).by(-1)
      end
      
      it "redirects to job offer view if saving fails" do
        Application.any_instance.stub(:delete).and_return(false)

        expect{
          get :decline, {id: @application.id}
        }.to change(Application, :count).by(0)
        response.should redirect_to(@application.job_offer)
      end
    end

    describe "having insufficient permissions" do

      before(:each) do
        sign_in @student
      end

      it "redirects to job offer view" do
        expect{
          get :decline, {id: @application.id}
        }.to change(Application, :count).by(0)
        response.should redirect_to(@job_offer)
      end
    end
  end

  describe "GET accept" do

    before(:each) do
      @application = FactoryGirl.create(:application, student: @student, job_offer: @job_offer)
    end

    describe "having sufficient permissions" do
      before(:each) do
        sign_in @job_offer.responsible_user
      end

      it "accepts a student and he/her is included in @job_offer.assigned_students" do
        get :accept, {id: @application.id}
        assigns(:application).job_offer.assigned_students.should include(@student)
      end

      it "declines all other students after accepting the last possible application" do
        @job_offer.vacant_posts = 1
        @job_offer.save
        student2 = FactoryGirl.create(:student)

        application_2 = FactoryGirl.create(:application, student: student2, job_offer: @job_offer)
        application_3 = FactoryGirl.create(:application, job_offer: @job_offer)

        expect{
          get :accept, { id: @application.id }
        }.to change(Application, :count).by(-3)
      end

      it "changes the job status to 'running' if the last possible application is accepted" do
        @job_offer.vacant_posts = 1
        @job_offer.save

        running = FactoryGirl.create(:job_status, name: 'running')

        get :accept, {id: @application.id}
        assigns(:application).job_offer.status.should eq(running)
      end

      it "keeps the job 'open' when there are still vacant_posts left" do
        @job_offer.vacant_posts = 2
        @job_offer.save

        get :accept, {id: @application.id}
        assigns(:application).job_offer.status.should eq(FactoryGirl.create(:job_status, name: 'open'))
      end

      it "sends two emails" do
        old_count = ActionMailer::Base.deliveries.count

        get :accept, {id: @application.id}

        ActionMailer::Base.deliveries.count.should == old_count + 2
      end

      it "renders errors if updating all objects failed" do
        working = FactoryGirl.create(:job_status, name: 'running')

        JobOffer.any_instance.stub(:save).and_return(false)

        get :accept, {id: @application.id}
        response.should redirect_to(@application.job_offer)
      end

      it "updates the job offers start date to the current date if it is 'from now on'" do
        @job_offer.flexible_start_date = true
        @job_offer.save!

        get :accept, {id: @application.id}
        assert_equal(@job_offer.reload.start_date, Date.current)
      end
    end

    describe "having insufficient permissions" do

      before(:each) do
        sign_in @student.user
      end

      it "redirects to job offer view" do
        expect{
          get :accept, {id: @application.id}
        }.to change(Application, :count).by(0)
        response.should redirect_to(@job_offer)
      end
    end
  end

  describe "POST create" do
    it "does not create an application if job is not open" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'running')
      @job_offer.save

      sign_in FactoryGirl.create(:student).user
      expect{
          post :create, { application: { job_offer_id: @job_offer.id} }
        }.not_to change(Application, :count).by(1)
    end

    it "does create an application if job is open" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save

      test_file = ActionDispatch::Http::UploadedFile.new({
        :filename => 'test_cv.pdf',
        :type => 'application/pdf',
        :tempfile => fixture_file_upload('/pdf/test_cv.pdf')
      })

      sign_in FactoryGirl.create(:student).user
      expect{
          post :create, { application: { job_offer_id: @job_offer.id}, attached_files: { file_attributes: [file: test_file] }}
        }.to change(Application, :count).by(1)
    end

    it "handles failing save call" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save

      user = FactoryGirl.create(:student).user

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)

      sign_in user
      post :create, { :application => { job_offer_id: @job_offer.id} }
      response.should redirect_to(job_offer_path(@job_offer))
      assert_equal(flash[:error], 'An error occured while applying. Please try again later.')
    end

    it "forbids attachments that are not a PDF" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save

      test_file = ActionDispatch::Http::UploadedFile.new({
        :filename => 'test_cv.pdf',
        :type => 'application/png',
        :tempfile => fixture_file_upload('/pdf/test_cv.pdf')
      })

      sign_in FactoryGirl.create(:student)
      expect{
          post :create, { :application => { job_offer_id: @job_offer.id}, attached_files: { file_attributes: [file: test_file] }}
        }.to change(Application, :count).by(0)
      response.should redirect_to(@job_offer)
    end

    it "only allows students to create applications" do
      sign_in FactoryGirl.create(:staff, employer: @job_offer.employer)
      expect{
          post :create, { :application => { job_offer_id: @job_offer.id}}
      }.to change(Application, :count).by(0)
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @user = FactoryGirl.create(:student).user
      sign_in @user
    end
    it "destroys the requested application" do
      application = FactoryGirl.create(:application, job_offer: @job_offer, user: @user)

      expect {
        delete :destroy, {id: application.to_param}
      }.to change(Application, :count).by(-1)
    end

    it "redirects to the job_offers page" do
      application = FactoryGirl.create(:application, job_offer: @job_offer, user: @user)

      delete :destroy, {id: application.to_param}
      response.should redirect_to(job_offer_path(@job_offer))
    end
  end
end
