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
  end

  describe "GET 'imprint'" do
    it "returns http success" do
      get 'imprint'
      response.should be_success
    end
  end

end
