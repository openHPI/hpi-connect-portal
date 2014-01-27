require 'spec_helper'


describe UserStatusesController do

  login_user FactoryGirl.create(:role, name: 'Student')

  let(:valid_attributes) { { "name" => "MyString" } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all user_statuses as @user_statuses" do
      user_status = FactoryGirl.create(:user_status)
      get :index, {}, valid_session
      assigns(:user_statuses).should eq(UserStatus.all)
    end
  end

  describe "GET show" do
    it "assigns the requested user_status as @user_status" do
      user_status = FactoryGirl.create(:user_status)
      get :show, {:id => user_status.to_param}, valid_session
      assigns(:user_status).should eq(user_status)
    end
  end

  describe "GET new" do
    it "assigns a new user_status as @user_status" do
      get :new, {}, valid_session
      assigns(:user_status).should be_a_new(UserStatus)
    end
  end

  describe "GET edit" do
    it "assigns the requested user_status as @user_status" do
      user_status = FactoryGirl.create(:user_status)
      get :edit, {:id => user_status.to_param}, valid_session
      assigns(:user_status).should eq(user_status)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserStatus" do
        expect {
          post :create, {:user_status => valid_attributes}, valid_session
        }.to change(UserStatus, :count).by(1)
      end

      it "assigns a newly created user_status as @user_status" do
        post :create, {:user_status => valid_attributes}, valid_session
        assigns(:user_status).should be_a(UserStatus)
        assigns(:user_status).should be_persisted
      end

      it "redirects to the created user_status" do
        post :create, {:user_status => valid_attributes}, valid_session
        response.should redirect_to(UserStatus.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_status as @user_status" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserStatus.any_instance.stub(:save).and_return(false)
        post :create, {:user_status => { "name" => "invalid value" }}, valid_session
        assigns(:user_status).should be_a_new(UserStatus)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserStatus.any_instance.stub(:save).and_return(false)
        post :create, {:user_status => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_status" do
        user_status = FactoryGirl.create(:user_status)
        
        UserStatus.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => user_status.to_param, :user_status => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested user_status as @user_status" do
        user_status = FactoryGirl.create(:user_status)
        put :update, {:id => user_status.to_param, :user_status => valid_attributes}, valid_session
        assigns(:user_status).should eq(user_status)
      end

      it "redirects to the user_status" do
        user_status = FactoryGirl.create(:user_status)
        put :update, {:id => user_status.to_param, :user_status => valid_attributes}, valid_session
        response.should redirect_to(user_status)
      end
    end

    describe "with invalid params" do
      it "assigns the user_status as @user_status" do
        user_status = FactoryGirl.create(:user_status)
        # Trigger the behavior that occurs when invalid params are submitted
        UserStatus.any_instance.stub(:save).and_return(false)
        put :update, {:id => user_status.to_param, :user_status => { "name" => "invalid value" }}, valid_session
        assigns(:user_status).should eq(user_status)
      end

      it "re-renders the 'edit' template" do
        user_status = FactoryGirl.create(:user_status)
        # Trigger the behavior that occurs when invalid params are submitted
        UserStatus.any_instance.stub(:save).and_return(false)
        put :update, {:id => user_status.to_param, :user_status => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_status" do
      user_status = FactoryGirl.create(:user_status)
      expect {
        delete :destroy, {:id => user_status.to_param}, valid_session
      }.to change(UserStatus, :count).by(-1)
    end

    it "redirects to the user_statuses list" do
      user_status = FactoryGirl.create(:user_status)
      delete :destroy, {:id => user_status.to_param}, valid_session
      response.should redirect_to(user_statuses_url)
    end
  end

end
