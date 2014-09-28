require 'spec_helper'

describe AlumniController do

  describe "GET new" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :new
      response.should_not redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :new
      response.should redirect_to(root_path)
    end
  end

  describe "GET index" do 

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :index
      response.should_not redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :index
      response.should redirect_to(root_path)
    end
  end

  describe "GET show" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :show, {id: FactoryGirl.create(:alumni).to_param}
      response.should_not redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :show, {id: FactoryGirl.create(:alumni).to_param}
      response.should redirect_to(root_path)
    end
  end

  describe "POST create" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      expect{
          post :create, { alumni: FactoryGirl.attributes_for(:alumni) }
        }.to change(Alumni, :count).by(1)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      expect{
          post :create, { alumni: FactoryGirl.attributes_for(:alumni) }
        }.to change(Alumni, :count).by(0)
      response.should redirect_to(root_path)
    end
  end
end
