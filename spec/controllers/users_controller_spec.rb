# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

require 'rails_helper'

describe UsersController do

  let(:valid_attributes) { { "email" => "test@test.de", "firstname" => "Alex", "lastname" => "Musterwomen" } }
  let(:valid_session) { {} }

  before :each do
   @user = FactoryGirl.create(:user)
   login @user
  end

   describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, {id: @user.to_param}, valid_session
      expect(assigns(:user)).to eq(@user)
    end

    it "should be accessible for the logged in user" do
      get :edit, {id: @user.to_param}, valid_session
      assert_template :edit
    end

    it "should not be accessible for other users" do
      login FactoryGirl.create(:user)
      get :edit, {id: @user.to_param}, valid_session
      assert_redirected_to root_path
    end
  end

  describe "PUT update" do

    it "should be possible to update parameters of the logged in user" do
      put :update, {id: @user.to_param, user: valid_attributes}, valid_session
      assert_redirected_to edit_user_path(@user)
    end

    it "should not be possible to update parameters of other users" do
      login FactoryGirl.create(:user)
      put :update, {id: @user.to_param, user: valid_attributes}, valid_session
      assert_redirected_to root_path
    end

    describe "with valid params" do
      it "updates the requested user" do
        expect_any_instance_of(User).to receive(:update).with({ "email" => "test100@test.com" })
        put :update, {id: @user.to_param, user: { email: "test100@test.com" }}, valid_session
      end

      it "assigns the requested user as @user" do
        put :update, {id: @user.to_param, user: valid_attributes}, valid_session
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the edit user again" do
        put :update, {id: @user.to_param, user: valid_attributes}, valid_session
        expect(response).to redirect_to(edit_user_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}, valid_session
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH update password" do

    it "assigns the current user as @user" do
      user = FactoryGirl.create :user
      login user
      patch :update_password, {user_id: @user.to_param, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'}}, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it "should be accessible for the logged in user" do
      patch :update_password, {user_id: @user.to_param, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'}}, valid_session
      assert_redirected_to edit_user_path(@user)
    end
  end

  describe "get forgotten password" do
    before :each do
      @user = FactoryGirl.create :user
      @user.update_attributes(email: "user1@example.com")
    end

    it "posts forgot_password" do
      ActionMailer::Base.deliveries = []
      old_password = @user.password
      params = {forgot_password: {email: "user1@example.com"} }
      post :forgot_password, params
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq(I18n.t('users.messages.password_resetted'))
      expect(User.find(@user.id).password).not_to eq(old_password)

      # sends an email with the new password to the user
      # because travis is so slow we have to assume that there are more than 1 email
      password_mail_index = nil
      ActionMailer::Base.deliveries.each_with_index { |mail, index|
          password_mail_index = index if mail.to[0]==@user.email && mail.to.count==1
        }
      expect(password_mail_index).not_to eq(nil)
      expect(ActionMailer::Base.deliveries[password_mail_index]).to have_content(User.find(@user.id).password)
      expect(ActionMailer::Base.deliveries[password_mail_index].to.count).to eq(1)
      expect(ActionMailer::Base.deliveries[password_mail_index].to[0]).to eq(User.find(@user.id).email)
    end

    it "ignores cases" do
      ActionMailer::Base.deliveries = []
      @user.update(email: "User1.Lastname@example.com")
      params = {forgot_password: {email: "user1.lastname@example.com"} }
      post :forgot_password, params
      expect(response).to redirect_to(root_path)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
