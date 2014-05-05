require 'spec_helper'

describe SessionsController do

  before :each do 
    @user = FactoryGirl.create :user, password: 'password', password_confirmation: 'password'
  end
  
  describe "POST create" do
    it "logs in user with correct email and password" do
      post 'create', {session: {email: @user.email, password: 'password'}}
      assert current_user == @user
    end

    it "redirects to root with incorrect password" do
      post 'create', {session: {email: @user.email, password: 'wrong password'}}
      response.should redirect_to(root_path)
    end

    it "redirects to root with incorrect email" do
      post 'create', {session: {email: 'some_test@email.com', password: 'password'}}
      response.should redirect_to(root_path)
    end
  end

  describe "DELETE destroy" do
    it "returns http success" do
      delete 'destroy'
      assert current_user.nil?
      response.should redirect_to(root_path)
    end
  end
end
