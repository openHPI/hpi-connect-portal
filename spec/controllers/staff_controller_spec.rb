require 'spec_helper'

describe StaffController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

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
      expect(assigns(:staff_members)).to eq(Staff.all.sort_by { |staff| [staff.lastname, staff.firstname] })
    end
  end

  describe "GET show" do
    it "assigns the requested staff as @staff" do
      get :show, {id: @staff.to_param}, valid_session
      expect(assigns(:staff)).to eq(@staff)
    end
  end

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
      expect(response).to redirect_to(staff_index_path)
    end
  end

  describe "GET new" do
    let(:employer) { FactoryGirl.create(:employer, activated: true) }

    before :each do
      logout
    end

    it "should render template without account" do
      get :new, ({token: employer.token})
      expect(response).to render_template("new")
    end

    it "should redirect to root if wrong token" do
      get :new, ({token: "wrong-token"})
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    let(:employer) { FactoryGirl.create(:employer, activated: true) }
    let(:valid_attributes) { {token: employer.token, user_attributes:  {firstname: "Max", lastname: "Mustermann", email: "test@testmail.de",
                                                          password: "test", password_confirmation: "test"} } }

    before :each do
      logout
    end

    it "creates staff" do
      employer.reload
      expect {
        post :create, {staff: valid_attributes}, valid_session
      }.to change(Staff, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    it "creates staff in right employer" do
      post :create, {staff: valid_attributes}, valid_session
      expect(Staff.last.firstname).to eq("Max")
      expect(Staff.last.employer).to eq(employer)
    end
  end
end
