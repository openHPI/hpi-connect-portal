require 'spec_helper'

describe UsersController do
  let(:student) { FactoryGirl.create(:student) }
  let(:staff) { FactoryGirl.create(:staff) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:employer) { FactoryGirl.create(:employer) }
  let(:default_params) { {format: :json, exclude_user: admin.to_param} }

  let(:valid_session) { {} }

  describe "GET show" do

    describe "as student" do
      before do
        login student.user
      end

      it "redirects to staff" do
        get :show, {id: staff.to_param}, valid_session
        response.should redirect_to staff_path(staff)
      end

      it "does not redirect to student" do
        second_student = FactoryGirl.create :student
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
        login staff.user
      end

      it "redirects to staff" do
        second_staff = FactoryGirl.create :staff
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
end
