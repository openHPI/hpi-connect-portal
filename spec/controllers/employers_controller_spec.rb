# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#

require 'rails_helper'

describe EmployersController do

  let(:staff) { FactoryGirl.create(:staff) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  let(:valid_attributes) { { name: "HCI", description: "Human Computer Interaction",
      number_of_employees: "50", place_of_business: "Potsdam", year_of_foundation: 1998,
      "staff_members_attributes"=>valid_staff_attributes } }
  let(:valid_staff_attributes) { {"0"=>{"user_attributes"=>{"firstname"=>"Bla", "lastname"=>"Keks", "email"=>"bla@keks.de", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}}} }
  let(:false_attributes) { { name: '' } }

  subject(:premium_package_id) { Employer::PACKAGES.index('premium') }
  subject(:free_package_id) { Employer::PACKAGES.index('free') }

  before(:each) do
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :pending)

    login admin
  end

  describe "GET index" do
    before(:each) do
      @employer = FactoryGirl.create(:employer)
    end

    it "assigns all employers as @employers" do
      login FactoryGirl.create(:student).user
      get :index, {}
      expect(assigns(:employers)).to eq(Employer.active)
    end
  end

  describe "GET show" do
    it "assigns the requested employer as @employer" do
      employer = FactoryGirl.create(:employer)
      get :show, { id: employer.to_param }
      expect(assigns(:employer)).to eq(employer)
    end
  end

  describe "GET new" do
    it "assigns a new employer as @employer" do
      get :new, {}
      expect(assigns(:employer)).to be_a_new(Employer)
    end
  end

  describe "GET edit" do
    describe "with sufficient access rights" do
      it "assigns the requested employer as @employer as admin" do
        employer = FactoryGirl.create(:employer)
        get :edit, { id: employer.to_param }
        expect(assigns(:employer)).to eq(employer)
      end

      it "assigns the requested employer as @employer as staff of employer" do
        employer = FactoryGirl.create(:employer)
        login FactoryGirl.create(:staff, employer: employer).user
        get :edit, { id: employer.to_param }
        expect(assigns(:employer)).to eq(employer)
      end
    end

    describe "with insufficient access rights it should redirect to employers path" do

      before(:each) do
        @employer = FactoryGirl.create(:employer)
      end

      it "as a student" do
        login FactoryGirl.create(:student).user
      end

      it "as a staff of another chair" do
        employer2 = FactoryGirl.create(:employer)
        login FactoryGirl.create(:staff, employer: employer2).user
      end

      after(:each) do
        get :edit, { id: @employer.to_param }
        expect(response).to redirect_to(employers_path)
        expect(flash[:notice]).to eql("You are not authorized to access this page.")
      end
    end
  end

  describe "POST create" do

    describe "with valid params" do

      it "creates a new employer" do
        expect {
          post :create, { employer: valid_attributes }
        }.to change(Employer, :count).by(1)
      end

      it "assigns a newly created employer as @employer" do
        post :create, { employer: valid_attributes }
        expect(assigns(:employer)).to be_a(Employer)
        expect(assigns(:employer)).to be_persisted
      end

      it "redirects to the created employer" do
        post :create, { employer: valid_attributes }
        expect(response).to redirect_to(home_employers_path)
      end

      it "sends 2 emails (one to admins and one to staff members)" do
        old_count = ActionMailer::Base.deliveries.count
        post :create, { employer: valid_attributes }
        expect(ActionMailer::Base.deliveries.count).to eq(old_count + 2)
      end
    end

    describe "with invalid params" do

      it "renders new again" do
        post :create, { employer: false_attributes }
        expect(response).to render_template("new")
      end
    end

    describe "with insufficient access rights" do

      before(:each) do
        login FactoryGirl.create(:student).user
      end

      it "should also create an employer (there are no insufficient access rights)" do
        employer = FactoryGirl.create(:employer)
        post :create, { employer: valid_attributes }
        expect(response).to redirect_to(home_employers_path)
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        @employer = FactoryGirl.create(:employer)
      end

      it "updates the requested employer" do
        expect_any_instance_of(Employer).to receive(:update).with({ "name" => "HCI", "description" => "Human Computer Interaction" } )
        put :update, { id: @employer.to_param, employer: { "name" => "HCI", "description" => "Human Computer Interaction" } }
      end

      it "assigns the requested employer as @employer" do
        put :update, { id: @employer.id, employer: valid_attributes }
        expect(assigns(:employer)).to eq(@employer)
      end

      it "redirects to the employer" do
        staff.update(employer: @employer)
        put :update, { id: @employer.id, employer: valid_attributes }
        expect(response).to redirect_to(@employer)
      end

      context "upgrade package" do
        it "sends two emails to staff and admin if a new package was booked" do
          old_count = ActionMailer::Base.deliveries.count
          put :update, { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: premium_package_id } }
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 2)
        end
      end

      context "downgrade package" do
        before(:each) do
          @employer.booked_package_id = premium_package_id
          @employer.requested_package_id = premium_package_id
          @employer.save
          @employer.reload
        end

        it "sends two emails to staff and admin if a new package was booked" do
          old_count = ActionMailer::Base.deliveries.count
          put :update, { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 2)
        end

        it "updates requested_package_id" do
          put :update, { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          @employer.reload
          expect(@employer.requested_package_id).to eq(free_package_id)
        end

        it "does not update booked_package_id" do
          put :update, { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          @employer.reload
          expect(@employer.booked_package_id).to eq(premium_package_id)
        end
      end

    end

    describe "with missing permission" do

      before(:each) do
        login FactoryGirl.create(:student).user
      end

      it "redirects to the employer index page" do
        employer = FactoryGirl.create(:employer)
        patch :update, { id: employer.id, employer: valid_attributes }
        expect(response).to redirect_to(employers_path)
      end
    end
  end

  describe "GET activate" do
    describe "as an admin" do

      before :each do
        login FactoryGirl.create(:user, :admin)
        @employer = FactoryGirl.create(:employer, activated: false)
      end

      it "should be accessible" do
        get :activate, ({ id: @employer.id })
        expect(response).to redirect_to(@employer)
      end

      it "should activate the employer" do
        get :activate, ({ id: @employer.id })
        @employer.reload
        assert @employer.activated
      end

      context "upgrade package" do
        before(:each) do
          @employer.booked_package_id = free_package_id
          @employer.requested_package_id = premium_package_id
          @employer.save
          @employer.reload
        end

        it "updates booked_package_id" do
          get :activate, ({ id: @employer.id })
          @employer.reload
          expect(@employer.booked_package_id).to eq(premium_package_id)
        end

        it "sends one email to staff to confirm new booked package" do
          old_count = ActionMailer::Base.deliveries.count
          get :activate, ({ id: @employer.id })
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 1)

          last_delivery = ActionMailer::Base.deliveries.last
          expect(last_delivery.body.raw_source).to include I18n.t("activerecord.attributes.employer.packages.premium")
        end
      end

      context "downgrade package" do
        before(:each) do
          @employer.booked_package_id = premium_package_id
          @employer.requested_package_id = free_package_id
          @employer.save
          @employer.reload
        end

        it "updates booked_package_id" do
          get :activate, ({ id: @employer.id })
          @employer.reload
          expect(@employer.booked_package_id).to eq(free_package_id)
        end

        it "sends one email to staff to confirm new booked package" do
          old_count = ActionMailer::Base.deliveries.count
          get :activate, ({ id: @employer.id })
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 1)

          last_delivery = ActionMailer::Base.deliveries.last
          expect(last_delivery.body.raw_source).to include I18n.t("activerecord.attributes.employer.packages.free")
        end
      end
    end

    it "should not be accessible for staff members" do
      staff = FactoryGirl.create(:staff)
      login staff.user
      get :activate, ({ id: FactoryGirl.create(:employer).id })
      expect(response).to redirect_to(employers_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end

    it "should not be accessible for students" do
      student = FactoryGirl.create(:student)
      login student.user
      get :activate, ({ id: FactoryGirl.create(:employer).id })
      expect(response).to redirect_to(employers_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end

    it "should delete staff of an deleted employer" do
      employer = FactoryGirl.create(:employer, activated: true)
      staff = FactoryGirl.create(:staff, employer: employer)
      staff2 = FactoryGirl.create(:staff, employer: employer)
      job_offer = FactoryGirl.create(:job_offer, employer: employer)
      student = FactoryGirl.create(:student)
      expect {
        delete :destroy, {id: employer.id}
        }.to change(Employer, :count).by(-1) and change(Staff, :count).by(-2) and change(JobOffer, :count).by(-1)
    end
  end

  describe "POST invite colleague" do
    let(:employer) { employer = FactoryGirl.create(:employer, activated: true) }

    before :each do
      ActionMailer::Base.deliveries = []
      login employer.staff_members.first.user
    end

    it "should redirect to employer show" do
      post :invite_colleague, ({id: employer.id, invite_colleague_email: {colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann"}})
      expect(response).to redirect_to(employer_path(employer))
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should not deliver Email for students" do
      login FactoryGirl.create(:student).user
      post :invite_colleague, ({id: employer.id, invite_colleague_email: {colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann"}})
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it "should not deliver for guest users" do
      logout
      post :invite_colleague, ({id: employer.id, invite_colleague_email: {colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann"}})
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

  end

  describe "GET export_all" do

    context "when logged in as admin" do
      before(:each) do
        login FactoryGirl.create :user, :admin
      end

      it "sends a CSV with all employers" do
        require 'csv'
        example_employer = FactoryGirl.create(:employer)
        example_employer_staff_member = example_employer.staff_members.first

        get :export_all

        csv = CSV.parse(response.body)
        csv_array = csv.to_a
        expect(csv[0]).to eq(%w{employer_name staff_member_full_name staff_member_email})
        expect(csv[1]).to eq([example_employer.name, example_employer_staff_member.full_name, example_employer_staff_member.email])
      end
    end

    context "when not logged in as admin" do
      before(:each) do
        login FactoryGirl.create :user
      end

      it "doesn't send a CSV" do
        get :export_all
        expect(response).to redirect_to(employers_path)
        expect(flash[:notice]).to eql("You are not authorized to access this page.")
      end
    end

  end

end
