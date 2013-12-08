require 'spec_helper'

describe ApplicationsController do

  let(:chair) { FactoryGirl.create(:chair, name: "Chair") }
  let(:research_assistant_role) {FactoryGirl.create(:role, :name => 'Research Assistant', :level => 2)}
  let(:student_role) {FactoryGirl.create(:role, :name => "Student")}
	let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :name => "open")} }
  before(:each) do
    @student = FactoryGirl.create(:user, :role => student_role)
    @job_offer = JobOffer.create! valid_attributes
  end

  describe "GET decline" do
    it "application should be deleted" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>research_assistant_role, :chair => @job_offer.chair)
      expect{
          get :decline, {:id => application.id}
        }.to change(Applications, :count).by(-1)
    end
    it "redirect to job offer view if user don't have permissions for declining" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      get :decline, {:id => application.id}
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET accept" do

    it "redirect to job offer view if user don't have permissions for accepting" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      get :accept, {:id => application.id}
      response.should redirect_to(@job_offer)
    end
    it "accepted student is assigned as @job_offer.assigned_student" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>research_assistant_role, :chair => @job_offer.chair)
      
      get :accept, {:id => application.id}
      assigned(:job_offer).assigned_student.should eq(@student)
    end
    it "declines all other students" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      application_2 = FactoryGirl.create(:application)
      application_3 = FactoryGirl.create(:application)
      sign_in FactoryGirl.create(:user,:role=>research_assistant_role, :chair => @job_offer.chair)

      expect{
        get :accept, {:id => application.id}
      }.to change(Applications, :count).by(-3)
    end
    it "application status should be 'working' if an application is accepted" do
      application = FactoryGirl.create(:application, :user => @student, :job_offer => @job_offer)
      sign_in FactoryGirl.create(:user,:role=>research_assistant_role, :chair => @job_offer.chair)

      expect{
        get :accept, {:id => application.id}
      }.to change(@job_offer, :status).to(FactoryGirl.create(:status, :name=>'working'))
    end
  end
end
