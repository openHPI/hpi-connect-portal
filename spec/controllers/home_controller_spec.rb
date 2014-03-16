require 'spec_helper'

describe HomeController do

  login_user FactoryGirl.create(:role, name: 'Student')

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
