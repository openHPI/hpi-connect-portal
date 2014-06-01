require 'spec_helper'

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
      assigns(:user).should eq(@user)
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
        User.any_instance.should_receive(:update).with({ "email" => "test100@test.com" })
        put :update, {id: @user.to_param, user: { email: "test100@test.com" }}, valid_session
      end

      it "assigns the requested user as @user" do
        put :update, {id: @user.to_param, user: valid_attributes}, valid_session
        assigns(:user).should eq(@user)
      end

      it "redirects to the edit user again" do
        put :update, {id: @user.to_param, user: valid_attributes}, valid_session
        response.should redirect_to(edit_user_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        User.any_instance.stub(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}, valid_session
        assigns(:user).should eq(@user)
      end

      it "re-renders the 'edit' template" do
        User.any_instance.stub(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "PATCH update password" do

    it "assigns the current user as @user" do
      user = FactoryGirl.create :user
      login user
      patch :update_password, {user_id: @user.to_param, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'}}, valid_session
      assigns(:user).should eq(user)
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
      old_password = @user.password
      params = {forgot_password: {email: "user1@example.com"} }
      post :forgot_password, params
      response.should redirect_to(root_path)
      flash[:notice].should eq(I18n.t('devise.passwords.changed_password'))
      User.find(@user).password.should_not eq(old_password)
      # sends an email with the new password to the user
      ActionMailer::Base.deliveries.count==1  
      ActionMailer::Base.deliveries[0].should have_content(User.find(@user).password)
      ActionMailer::Base.deliveries[0].to[0].should eq(User.find(@user).email)
    end

  end
end