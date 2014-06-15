require 'spec_helper'

describe HomeController do

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns latest 5 job_offers" do
      6.times { |i| FactoryGirl.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active) }
      get 'index'
      assigns(:job_offers).length.should eq(5)
      assigns(:job_offers).should_not include(JobOffer.find_by_title("Testjob1"))
    end

    it "does not assign pending JobOffers" do
      5.times { |i| FactoryGirl.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active) }
      pending_job = FactoryGirl.create(:job_offer, title: "Pending Job", status: JobStatus.pending)
      get 'index'
      assigns(:job_offers).should_not include(pending_job)
    end

    it "assigns latest 5 employers" do
      6.times { |i| FactoryGirl.create(:employer, name:"TestEmployer#{i+1}") }
      get 'index'
      assigns(:employers).length.should eq(5)
      assigns(:employers).should_not include(JobOffer.find_by_title("TestEmployer1"))
    end

    it "does not assign not activated employers" do
      3.times { |i| FactoryGirl.create(:employer, name:"TestEmployer#{i+1}") }
      not_activated_employer = FactoryGirl.create(:employer, activated: false, name:"NotActiveEmployer")
      get 'index'
      assigns(:employers).should_not include not_activated_employer
    end

  end

  describe "GET 'imprint'" do
    it "returns http success" do
      get 'imprint'
      response.should be_success
    end
  end

end
