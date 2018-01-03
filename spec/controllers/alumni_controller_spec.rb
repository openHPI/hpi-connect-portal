require 'rails_helper'

describe AlumniController do

  describe "GET new" do

    it "should be available for admins" do
      login FactoryBot.create :user, :admin
      get :new
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryBot.create :user
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET index" do

    it "should be available for admins" do
      login FactoryBot.create :user, :admin
      get :index
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryBot.create :user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET show" do

    it "should be available for admins" do
      login FactoryBot.create :user, :admin
      get :show, {id: FactoryBot.create(:alumni).to_param}
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login FactoryBot.create :user
      get :show, {id: FactoryBot.create(:alumni).to_param}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST create" do

    it "should be available for admins" do
      login FactoryBot.create :user, :admin
      expect{
          post :create, { alumni: FactoryBot.attributes_for(:alumni) }
        }.to change(Alumni, :count).by(1)
    end

    it "should not be available for anyone else" do
      login FactoryBot.create :user
      expect{
          post :create, { alumni: FactoryBot.attributes_for(:alumni) }
        }.to change(Alumni, :count).by(0)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET remind_all" do

    it "redirects to alumni_path" do
      ActionMailer::Base.deliveries = []
      login FactoryBot.create :user, :admin
      FactoryBot.create :alumni
      FactoryBot.create :alumni
      get :remind_all
      expect(response).to redirect_to(alumni_index_path)
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "redirects to root if not admin" do
      login FactoryBot.create :user
      get :remind_all
      expect(response).to redirect_to(root_path)
    end

  end
end
