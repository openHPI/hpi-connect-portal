require 'rails_helper'

describe StaffController do
  let!(:staff) { FactoryBot.create(:staff) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  describe "GET index" do
    context "as admin" do
      before(:each) do
        login admin
      end

      it "assigns all staff as @staff" do
        get :index
        expect(assigns(:staff_members)).to eq(Staff.all.sort_by { |staff| [staff.lastname, staff.firstname] })
      end
    end

    context "when logged out" do
      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET show" do
    context "as a student" do
      before(:each) do
        login FactoryBot.create(:student).user
      end

      it "assigns the requested staff as @staff" do
        get :show, params: { id: staff.id }
        expect(assigns(:staff)).to eq(staff)
      end
    end
  end

  describe "DELETE destroy" do
    context "as admin user" do
      before(:each) do
        login admin
      end

      describe "destroys the requested staff" do
        it "should delete the staff object" do
          expect { delete :destroy, params: { id: staff.id } }.to change(Staff, :count).by(-1)
        end

        it "should delete the user object" do
          expect { delete :destroy, params: { id: staff.id } }.to change(User, :count).by(-1)
        end
      end

      it "redirects to the staff list" do
        delete :destroy, params: { id: staff.id }
        expect(response).to redirect_to(staff_index_path)
      end
    end

    context "as staff of another employer" do
      before(:each) do
        login FactoryBot.create(:staff).user
      end

      it "redirects to the staff member page" do
        delete :destroy, params: { id: staff.id }
        expect(response).to redirect_to(staff)
      end

      it "doesn't destroy the staff member" do
        expect { delete :destroy, params: { id: staff.id } }.to change(Staff, :count).by(0)
      end
    end
  end

  describe "GET new" do
    before(:each) do
      logout
    end

    it "should render template without account" do
      get :new, params: { token: staff.employer.token }
      expect(response).to render_template("new")
    end

    it "should redirect to root if wrong token" do
      get :new, params: { token: "wrong-token" }
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    let(:employer) { FactoryBot.create(:employer, activated: true) }
    let(:valid_attributes) { {token: employer.token, user_attributes:  {firstname: "Max", lastname: "Mustermann", email: "test@testmail.de",
                                                          password: "test", password_confirmation: "test"} } }

    before(:each) do
      logout
    end

    it "creates staff" do
      employer.reload
      expect {
        post :create, params: { staff: valid_attributes }
      }.to change(Staff, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    it "creates staff in right employer" do
      post :create, params: { staff: valid_attributes }
      expect(Staff.last.firstname).to eq("Max")
      expect(Staff.last.employer).to eq(employer)
    end
  end
end
