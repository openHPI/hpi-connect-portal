require 'spec_helper'

describe ImprintController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
