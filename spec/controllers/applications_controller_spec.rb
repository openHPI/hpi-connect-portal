require 'spec_helper'

describe ApplicationsController do

  let(:chair) { FactoryGirl.create(:chair, name: "Chair") }
  let(:staff_role) {FactoryGirl.create(:role, :name => 'Staff', :level => 2)}
  let(:student_role) {FactoryGirl.create(:role, :name => "Student")}
  let(:responsible_user) {  FactoryGirl.create(:user, chair: chair, role: staff_role)}
	let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :name => "open"), "responsible_user_id" => responsible_user.id} }
  before(:each) do
    @student = FactoryGirl.create(:user, :role => student_role, :email => 'test@example.com')
    @job_offer = JobOffer.create! valid_attributes
  end

  describe "GET decline" do
    it "deletes application" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>staff_role, :chair => @job_offer.chair)
      expect{
          get :decline, {:id => application.id}
        }.to change(Application, :count).by(-1)
    end
    it "redirects to job offer view if user don't have permissions for declining" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in @student
      
      get :decline, {:id => application.id}
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET accept" do

    it "redirects to job offer view if user don't have permissions for accepting" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in @student

      get :accept, {:id => application.id}
      response.should redirect_to(@job_offer)
    end

    it "accepts student is assigned as @job_offer.assigned_student" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>staff_role, :chair => @job_offer.chair)
      
      get :accept, {:id => application.id}
      assigns(:application).job_offer.assigned_student.should eq(@student)
    end

    it "declines all other students" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      application_2 = FactoryGirl.create(:application, :job_offer => @job_offer)
      application_3 = FactoryGirl.create(:application, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>staff_role, :chair => @job_offer.chair)

      expect{
        get :accept, {:id => application.id}
      }.to change(Application, :count).by(-3)
    end

    it "application status should be 'working' if an application is accepted" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      working = FactoryGirl.create(:job_status, :name=>'running')
      
      sign_in FactoryGirl.create(:user,:role=>staff_role, :chair => @job_offer.chair)

      get :accept, {:id => application.id}
      assigns(:application).job_offer.status.should eq(working)
    end

    it "sends two emails" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>staff_role, :chair => @job_offer.chair)
      
      old_count = ActionMailer::Base.deliveries.count

      get :accept, {:id => application.id}

      ActionMailer::Base.deliveries.count.should == old_count + 2
    end
  end

  describe "POST create" do
    it "does not create an application if job is not open" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'running')
      @job_offer.save

      sign_in FactoryGirl.create(:user,:role=>student_role, :chair => @job_offer.chair)
      expect{
          post :create, { :application => {:job_offer_id => @job_offer.id} }
        }.not_to change(Application, :count).by(1)
    end

    it "does create an application if job is open" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save
      
      sign_in FactoryGirl.create(:user,:role=>student_role, :chair => @job_offer.chair)
      expect{
          post :create, { :application => {:job_offer_id => @job_offer.id} }
        }.to change(Application, :count).by(1)
    end

    it "handles failing save call" do
      @job_offer.status = FactoryGirl.create(:job_status, name: 'open')
      @job_offer.save

      user = FactoryGirl.create(:user,:role=>student_role, :chair => @job_offer.chair)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      post :create, { :application => {:job_offer_id => @job_offer.id} }
      response.should redirect_to(job_offer_path(@job_offer))
      assert_equal(flash[:error], 'An error occured while applying. Please try again later.')
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested application" do
      user = FactoryGirl.create(:user,:role=>student_role, :chair => @job_offer.chair)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      expect {
        delete :destroy, {:id => application.to_param}
      }.to change(Application, :count).by(-1)
    end

    it "redirects to the job_offers page" do
      user = FactoryGirl.create(:user,:role=>student_role, :chair => @job_offer.chair)

      application = FactoryGirl.create(:application, job_offer: @job_offer, user: user)
      
      sign_in user
      delete :destroy, {:id => application.to_param}
      response.should redirect_to(job_offer_path(@job_offer))
    end
  end
end
