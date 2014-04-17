require 'spec_helper'

describe HomeController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns latest 5 job_offers" do
      6.times { |i| FactoryGirl.create(:job_offer, title:"Testjob#{i+1}") }
      get 'index'
      assigns(:job_offers).length.should eq(5)
      assigns(:job_offers).should_not include(JobOffer.find_by_title("Testjob1"))
    end

    it "assigns latest 3 employers" do
      4.times { |i| FactoryGirl.create(:employer, name:"TestEmployer#{i+1}") }
      get 'index'
      assigns(:employers).length.should eq(3)
      assigns(:employers).should_not include(JobOffer.find_by_title("TestEmployer1"))
    end
  end

  describe "GET 'imprint'" do
    it "returns http success" do
      get 'imprint'
      response.should be_success
    end
  end

end
