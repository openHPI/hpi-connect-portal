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

    it "redirects to root with incorrect password and shows flash message" do
      post 'create', {session: {email: @user.email, password: 'wrong password'}}
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eql(I18n.t('errors.configuration.invalid_email_or_password'))
    end

    it "redirects to root with incorrect email" do
      post 'create', {session: {email: 'some_test@email.com', password: 'password'}}
      expect(response).to redirect_to(root_path)
    end

    it "redirects to employers home if staff logs in" do
      staff = FactoryGirl.create :staff
      post 'create', {session: {email: staff.email, password: "password123"}}
      expect(response).to redirect_to(home_employers_path)
    end
  end

  describe "DELETE destroy" do
    it "returns http success" do
      delete 'destroy'
      assert current_user.nil?
      expect(response).to redirect_to(root_path)
    end
  end
end
