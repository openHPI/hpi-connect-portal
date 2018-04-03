require 'rails_helper'

describe SessionsController do
  let(:user) { FactoryBot.create :user, password: 'password', password_confirmation: 'password' }
  let(:staff) { FactoryBot.create :staff }
  let(:alumnus) { FactoryBot.build(:user, :alumnus, email: 'bad@student.hpi.de') }

  describe "POST create" do
    it "logs in user with correct email and password" do
      post 'create', {session: {email: user.email, password: 'password'}}
      expect(current_user).to eq(user)
    end

    it "logs in user with correct email and password (case insensitive)" do
      post 'create', {session: {email: user.email.swapcase, password: 'password'}}
      expect(current_user).to eq(user)
    end

    it "redirects to root with incorrect password and shows flash message" do
      post 'create', {session: {email: user.email, password: 'wrong password'}}
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eql(I18n.t('errors.configuration.invalid_email_or_password'))
    end

    it "redirects to root with incorrect email" do
      post 'create', {session: {email: 'some_test@email.com', password: 'password'}}
      expect(response).to redirect_to(root_path)
    end

    it "redirects to employers home if staff logs in" do
      post 'create', {session: {email: staff.email, password: "password123"}}
      expect(response).to redirect_to(home_employers_path)
    end

    it "redirects to user edit page if alumnus with invalid mail adress logs in" do
      alumnus.save(validate: false)
      post 'create', {session: {email: alumnus.email, password: 'password123'}}
      expect(response).to redirect_to(edit_user_path(alumnus))
      expect(flash[:error]).to eql(I18n.t('alumni.choose_another_email'))
      expect(current_user).to eq(alumnus)
    end
  end

  describe "DELETE destroy" do
    before :each do
      post 'create', {session: {email: user.email, password: 'password'}}
    end

    it "logs out current user" do
      delete 'destroy'
      expect(current_user).to eq(nil)
      expect(response).to redirect_to(root_path)
    end
  end
end
