require 'spec_helper'

describe ImprintController do

  before(:each) do
    post '/signin', { session: { email: FactoryGirl.create(:student).user.email, password: 'password123' }}
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
