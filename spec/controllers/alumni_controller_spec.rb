require 'spec_helper'

describe AlumniController do

  describe "GET new" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :new
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET index" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :index
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET show" do

    it "should be available for admins" do
      login FactoryGirl.create :user, :admin
      get :show, {id: FactoryGirl.create(:alumni).to_param}
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryGirl.create :user
      get :show, {id: FactoryGirl.create(:alumni).to_param}
      expect(response).to redirect_to(root_path)
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
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET remind_all" do

    it "redirects to alumni_path" do
      ActionMailer::Base.deliveries = []
      login FactoryGirl.create :user, :admin
      FactoryGirl.create :alumni
      FactoryGirl.create :alumni
      get :remind_all
      expect(response).to redirect_to(alumni_index_path)
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "redirects to root if not admin" do
      login FactoryGirl.create :user
      get :remind_all
      expect(response).to redirect_to(root_path)
    end

  end
end
