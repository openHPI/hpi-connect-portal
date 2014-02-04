require 'spec_helper'

describe UsersController do
  let(:student) { FactoryGirl.create(:user, :student) }
  let(:staff) { FactoryGirl.create(:user, :staff) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:employer) { FactoryGirl.create(:employer)}
  let(:default_params) { {format: :json, exclude_user: admin.to_param} }

  let(:valid_session) { {} }

  describe "GET show" do

    describe "as student" do
      before do
        sign_in student
      end

      it "redirects to staff" do
        get :show, {id: staff.to_param}, valid_session
        response.should redirect_to staff_path(staff)
      end

      it "does not redirect to student" do
        second_student = FactoryGirl.create :user, :student
        get :show, {id: second_student.to_param}, valid_session
        response.should redirect_to root_path
      end

      it "redirects to root" do
        get :show, {id: admin.to_param}, valid_session
        response.should redirect_to root_path
      end
    end

    describe "as staff" do
      before do
        sign_in staff
      end

      it "redirects to staff" do
        second_staff = FactoryGirl.create :user, :staff
        get :show, {id: second_staff.to_param}, valid_session
        response.should redirect_to staff_path(second_staff)
      end

      it "does not redirect to student" do
        get :show, {id: student.to_param}, valid_session
        response.should redirect_to student_path(student)
      end

      it "redirects to root" do
        get :show, {id: admin.to_param}, valid_session
        response.should redirect_to root_path
      end
    end

  end

  describe "GET userlist" do

    before do
      sign_in admin
    end

    it "should not return users when user is admin" do
      second_student = FactoryGirl.create :user, :student
      get :userlist, default_params
      parsed_response = JSON.parse response.body 
      parsed_response["is_deputy"].should == false
      parsed_response["users"].should == nil
    end

    it "should not return users when current_user is not allowed" do
      sign_in student
      employer = FactoryGirl.create(:employer)
      staff.update(employer: employer)
      FactoryGirl.create(:user, :staff, employer: employer)
      get :userlist, {format: :json, exclude_user: staff.to_param}
      parsed_response = JSON.parse response.body 
      parsed_response["is_deputy"].should == false
      parsed_response["users"].should == nil
    end

    it "only returns list of all students and staff of this employer except the user itself" do
      a_student = FactoryGirl.create :user, :student
      staff_member = FactoryGirl.create :user, :staff, employer: employer
      deputy = FactoryGirl.create :user, :staff, employer: employer
      employer.update deputy: deputy
      FactoryGirl.create :user, :staff, employer: FactoryGirl.create(:employer)

      get :userlist, {format: :json, exclude_user: deputy.to_param}
      parsed_response = JSON.parse response.body 
      parsed_response["is_deputy"].should == true
      expect(parsed_response["users"].size).to equal(2)
      expect(parsed_response["users"][0]["full_name"]).to eq a_student.full_name
      expect(parsed_response["users"][1]["full_name"]).to eq staff_member.full_name
    end

  end

end
