require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'Admin', level: 1) }

  let(:valid_attributes) { { "firstname" => "Mister", "lastname" => "Awesome", "email" => "test@example.com", :semester => "1", :education => "Master", :academic_program => "Volkswirtschaftslehre", "role" => student_role } }
  let(:false_attributes) { { "firstname" => 123 } }
  let(:valid_session) { {} }

  before(:each) do
  	sign_in FactoryGirl.create(:user)
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      sign_in user
      get :edit, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end

    it "only allows the user or admin to edit" do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}, valid_session
      response.should redirect_to(user)
	end
  end

  describe "PUT update" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      sign_in user
      put :update, { :id => user.id, :user => valid_attributes }, valid_session
      assigns(:user).should eq(user)
    end

    it "only allows the user or admin to update" do
      user = User.create! valid_attributes
      put :update, { :id => user.id, :user => valid_attributes }, valid_session
      response.should redirect_to(user)
	  end

    it "handles a failing update call" do
      troubling_user = FactoryGirl.create(:user)

      user = User.create! valid_attributes
      sign_in user
      patch :update, { :id => user.id, :user => { 'email' => troubling_user.email} }, valid_session
      flash[:error].should eql("Error while updating profile.")
    end
    describe "beeing a student" do
      it "redirects to the student path on success" do
        student = FactoryGirl.create(:user, role: student_role)
        sign_in student
        put :update, { :id => student.id, :user => valid_attributes }, valid_session
        flash[:error].should be_nil
        response.should redirect_to edit_student_path(student)
      end
    end

    describe "beeing a student" do
      it "redirects to the student path on success" do
        student = FactoryGirl.create(:user, role: student_role)
        sign_in student
        put :update, { :id => student.id, :user => valid_attributes }, valid_session
        flash[:error].should be_nil
        response.should redirect_to edit_student_path(student)
      end
    end

    describe "beeing no student" do
      it "redirects to the root path on success" do
        user = FactoryGirl.create(:user, role: admin_role)
        sign_in user
        put :update, { :id => user.id, :user => valid_attributes }, valid_session
        flash[:error].should be_nil
        response.should redirect_to root_path
      end
    end

  end


end
