require 'spec_helper'

describe ApplicationsController do

  let(:employer) { FactoryGirl.create(:employer) }
  let(:staff_role) {FactoryGirl.create(:role, :staff)}
  let(:student_role) {FactoryGirl.create(:role, :student)}
  let(:responsible_user) {  FactoryGirl.create(:user, employer: employer, role: staff_role)}
	let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :name => "open"), "responsible_user_id" => responsible_user.id} }
  before(:each) do
    @student = FactoryGirl.create(:user, :role => student_role, :email => 'test@example.com')
    @job_offer = FactoryGirl.create(:job_offer)
  end

  describe "GET decline" do
    before do
      @application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
    end

    it "deletes application" do
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)
      expect{
          get :decline, {:id => @application.id}
        }.to change(Application, :count).by(-1)
    end

    it "redirects to job offer view if user don't have permissions for declining" do
      sign_in @student
      
      get :decline, {:id => @application.id}
      response.should redirect_to(@job_offer)
    end

    it "redirects to job offer view if saving fails" do
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)

      Application.any_instance.stub(:delete).and_return(false)

      get :decline, {:id => @application.id}
      response.should redirect_to(@application.job_offer)
    end
  end

  describe "GET accept" do

    before do
      @application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
    end

    it "redirects to job offer view if user don't have permissions for accepting" do
      sign_in @student

      get :accept, {:id => @application.id}
      response.should redirect_to(@job_offer)
    end

    it "accepts a student and he/her is included in @job_offer.assigned_students" do
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)
      
      get :accept, {:id => @application.id}
      assigns(:application).job_offer.assigned_students.should include(@student)
    end

    it "declines all other students after accepting the last possible application" do
      @job_offer.vacant_posts = 2
      @job_offer.save
      student2 = FactoryGirl.create(:user, :role => student_role, :email => 'test1234@example.com')

      application_2 = FactoryGirl.create(:application, :user => student2, :job_offer => @job_offer)
      application_3 = FactoryGirl.create(:application, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)

      get :accept, {:id => @application.id}

      expect{
        get :accept, {:id => application_2.id}
      }.to change(Application, :count).by(-2)
    end

    it "job status should be 'running' if the last possible application is accepted" do
      @job_offer.vacant_posts = 1
      @job_offer.save
      
      running = FactoryGirl.create(:job_status, :name=>'running')
      
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)

      get :accept, {:id => @application.id}
      assigns(:application).job_offer.status.should eq(running)
    end

    it "sends two emails" do
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)
      
      old_count = ActionMailer::Base.deliveries.count

      get :accept, {:id => @application.id}

      ActionMailer::Base.deliveries.count.should == old_count + 2
    end

    it "renders errors if updating all objects failed" do
      working = FactoryGirl.create(:job_status, :name=>'running')
      
      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)

      JobOffer.any_instance.stub(:save).and_return(false)

      get :accept, {:id => @application.id}
      response.should redirect_to(@application.job_offer)
    end

    it "updates the job offers start date to the current date if it is 'from now on'" do
      @job_offer.flexible_start_date = true
      @job_offer.save!

      sign_in FactoryGirl.create(:user,:role=>staff_role, :employer => @job_offer.employer)

      get :accept, {:id => @application.id}
      assert_equal(@job_offer.reload.start_date, Date.current)
    end
  end

  describe "POST create" do
    it "does not create an application if job is not open" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'running')
      @job_offer.save

      sign_in FactoryGirl.create(:user,:role=>student_role, :employer => @job_offer.employer)
      expect{
          post :create, { :application => {:job_offer_id => @job_offer.id} }
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
      
      sign_in FactoryGirl.create(:user,:role=>student_role, :employer => @job_offer.employer)
      expect{
          post :create, { :application => {:job_offer_id => @job_offer.id}, :attached_files => {:file_attributes => [:file => test_file] }}
        }.to change(Application, :count).by(1)
    end

    it "handles failing save call" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save

      user = FactoryGirl.create(:user,:role=>student_role, :employer => @job_offer.employer)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      post :create, { :application => {:job_offer_id => @job_offer.id} }
      response.should redirect_to(job_offer_path(@job_offer))
      assert_equal(flash[:error], 'An error occured while applying. Please try again later.')
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested application" do
      user = FactoryGirl.create(:user,:role=>student_role, :employer => @job_offer.employer)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      expect {
        delete :destroy, {:id => application.to_param}
      }.to change(Application, :count).by(-1)
    end

    it "redirects to the job_offers page" do
      user = FactoryGirl.create(:user,:role=>student_role, :employer => @job_offer.employer)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      delete :destroy, {:id => application.to_param}
      response.should redirect_to(job_offer_path(@job_offer))
    end
  end
end
