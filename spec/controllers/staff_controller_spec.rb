require 'spec_helper'

describe StaffController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  let(:valid_attributes) { { "firstname" => "Jane", "lastname" => "Doe", "employer" => FactoryGirl.create(:employer), "email" => "test@example"} }
  let(:admin_role) { FactoryGirl.create(:role, :admin) }
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  let(:valid_session) { {} }

  before(:each) do
    @staff = FactoryGirl.create(:staff)
  end

  describe "GET index" do
    it "assigns all staff as @staff" do
      admin = FactoryGirl.create :user, :admin
      login admin

      get :index, {}, valid_session
      assigns(:staff_members).should eq(Staff.all.sort_by { |staff| [staff.lastname, staff.firstname] })
    end
  end

  describe "GET show" do
    it "assigns the requested staff as @staff" do
      get :show, {id: @staff.to_param}, valid_session
      assigns(:staff).should eq(@staff)
    end
  end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Staff" do
  #       expect {
  #         post :create, {:staff => valid_attributes}, valid_session
  #       }.to change(Staff, :count).by(1)
  #     end

  #     it "assigns a newly created staff as @staff" do
  #       post :create, {:staff => valid_attributes}, valid_session
  #       assigns(:staff).should be_a(Staff)
  #       assigns(:staff).should be_persisted
  #     end

  #     it "redirects to the created staff" do
  #       post :create, {:staff => valid_attributes}, valid_session
  #       response.should redirect_to(Staff.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved staff as @staff" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Staff.any_instance.stub(:save).and_return(false)
  #       post :create, {:staff => {  }}, valid_session
  #       assigns(:staff).should be_a_new(Staff)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Staff.any_instance.stub(:save).and_return(false)
  #       post :create, {:staff => {  }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  describe "DELETE destroy" do
    before(:each) do
      admin = FactoryGirl.create(:user, :admin)
      login admin
    end

    describe "destroys the requested staff" do
      before(:each) do
        @staff = FactoryGirl.create(:staff)
      end

      it "should delete the staff object" do
        expect { delete :destroy, {id: @staff.to_param}, valid_session }.to change(Staff, :count).by(-1)
      end

      it "should delete the user object" do
        expect { delete :destroy, {id: @staff.to_param}, valid_session }.to change(User, :count).by(-1)
      end
    end

    it "redirects to the staff list" do
      staff = FactoryGirl.create(:staff)
      delete :destroy, {id: staff.to_param}, valid_session
      response.should redirect_to(staff_index_path)
    end
  end
end
