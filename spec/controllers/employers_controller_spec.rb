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
  let!(:employer) { FactoryBot.create(:employer) }
  let!(:premium_employer) { FactoryBot.create(:employer, :premium) }
  let(:staff) { FactoryBot.create(:staff) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:student) { FactoryBot.create(:student) }

  let(:valid_attributes) { { name: "HCI", description: "Human Computer Interaction",
      number_of_employees: "50", place_of_business: "Potsdam", year_of_foundation: 1998,
      "staff_members_attributes"=>valid_staff_attributes } }
  let(:valid_staff_attributes) { {"0"=>{"user_attributes"=>{"firstname"=>"Bla", "lastname"=>"Keks", "email"=>"bla@keks.de", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}}} }
  let(:false_attributes) { { name: '' } }

  subject(:premium_package_id) { Employer::PACKAGES.index('premium') }
  subject(:free_package_id) { Employer::PACKAGES.index('free') }

  before(:each) do
    login admin
  end

  describe "GET index" do
    before(:each) do
      FactoryBot.create(:employer)
    end

    it "assigns all employers as @employers" do
      login FactoryBot.create(:student).user
      get :index
      expect(assigns(:employers)).to eq(Employer.active)
    end
  end

  describe "GET show" do
    let!(:employer) { FactoryBot.create(:employer) }

    context "if employer exists" do
      it "assigns the requested employer as @employer" do
        get :show, params: { id: employer.to_param }
        expect(assigns(:employer)).to eq(employer)
      end
    end

    context "if employer does not exist" do
      it "redirects to root path" do
        get :show, params: { id: Employer.last.id + 1 }
        expect(response).to redirect_to(root_path)
      end

      it "shows an error message" do
        get :show, params: { id: Employer.last.id + 1 }
        expect(flash[:error]).to eq(I18n.t('errors.not_found'))
      end
    end
  end

  describe "GET new" do
    it "assigns a new employer as @employer" do
      get :new
      expect(assigns(:employer)).to be_a_new(Employer)
    end
  end

  describe "GET edit" do
    describe "with sufficient access rights" do
      it "assigns the requested employer as @employer as admin" do
        employer = FactoryBot.create(:employer)
        get :edit, params: { id: employer.to_param }
        expect(assigns(:employer)).to eq(employer)
      end

      it "assigns the requested employer as @employer as staff of employer" do
        employer = FactoryBot.create(:employer)
        login FactoryBot.create(:staff, employer: employer).user
        get :edit, params: { id: employer.to_param }
        expect(assigns(:employer)).to eq(employer)
      end
    end

    describe "with insufficient access rights it should redirect to employers path" do

      before(:each) do
        @employer = FactoryBot.create(:employer)
      end

      it "as a student" do
        login student.user
      end

      it "as a staff member of another employer" do
        login FactoryBot.create(:staff).user
      end

      after(:each) do
        get :edit, params: { id: @employer.to_param }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eql("You are not authorized to access this page.")
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new employer" do
        expect {
          post :create, params: { employer: valid_attributes }
        }.to change(Employer, :count).by(1)
      end

      it "assigns a newly created employer as @employer" do
        post :create, params: { employer: valid_attributes }
        expect(assigns(:employer)).to be_a(Employer)
        expect(assigns(:employer)).to be_persisted
      end

      it "redirects to the created employer" do
        post :create, params: { employer: valid_attributes }
        expect(response).to redirect_to(home_employers_path)
      end

      it "sends 2 emails (one to admins and one to staff members)" do
        old_count = ActionMailer::Base.deliveries.count
        post :create, params: { employer: valid_attributes }
        expect(ActionMailer::Base.deliveries.count).to eq(old_count + 2)
      end
    end

    describe "with invalid params" do
      it "renders new again" do
        post :create, params: { employer: false_attributes }
        expect(response).to render_template("new")
      end
    end

    describe "with insufficient access rights" do
      before(:each) do
        login student.user
      end

      it "should also create an employer (there are no insufficient access rights)" do
        employer = FactoryBot.create(:employer)
        post :create, params: { employer: valid_attributes }
        expect(response).to redirect_to(home_employers_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        @employer = FactoryBot.create(:employer)
      end

      it "updates the requested employer" do
        expect_any_instance_of(Employer).to receive(:update).with({ "name" => "HCI", "description" => "Human Computer Interaction" } )
        put :update, params: { id: @employer.to_param, employer: { "name" => "HCI", "description" => "Human Computer Interaction" } }
      end

      it "assigns the requested employer as @employer" do
        put :update, params: { id: @employer.id, employer: valid_attributes }
        expect(assigns(:employer)).to eq(@employer)
      end

      it "redirects to the employer" do
        staff.update(employer: @employer)
        put :update, params: { id: @employer.id, employer: valid_attributes }
        expect(response).to redirect_to(@employer)
      end

      context "upgrade package" do
        it "sends two emails to staff and admin if a new package was booked" do
          old_count = ActionMailer::Base.deliveries.count
          put :update, params: { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: premium_package_id } }
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
          put :update, params: { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 2)
        end

        it "updates requested_package_id" do
          put :update, params: { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          @employer.reload
          expect(@employer.requested_package_id).to eq(free_package_id)
        end

        it "does not update booked_package_id" do
          put :update, params: { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: free_package_id } }
          @employer.reload
          expect(@employer.booked_package_id).to eq(premium_package_id)
        end
      end

    end

    describe "with missing permission" do
      before(:each) do
        login student.user
      end

      it "redirects to the employer index page" do
        patch :update, params: { id: employer.id, employer: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET activate" do
    describe "as an admin" do
      before :each do
        login admin
        @employer = FactoryBot.create(:employer, activated: false)
      end

      it "should be accessible" do
        get :activate, params: { id: @employer.id }
        expect(response).to redirect_to(@employer)
      end

      it "should activate the employer" do
        get :activate, params: { id: @employer.id }
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
          get :activate, params: { id: @employer.id }
          @employer.reload
          expect(@employer.booked_package_id).to eq(premium_package_id)
        end

        it "sends one email to staff to confirm new booked package" do
          old_count = ActionMailer::Base.deliveries.count
          get :activate, params: { id: @employer.id }
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
          get :activate, params: { id: @employer.id }
          @employer.reload
          expect(@employer.booked_package_id).to eq(free_package_id)
        end

        it "sends one email to staff to confirm new booked package" do
          old_count = ActionMailer::Base.deliveries.count
          get :activate, params: { id: @employer.id }
          expect(ActionMailer::Base.deliveries.count).to eq(old_count + 1)

          last_delivery = ActionMailer::Base.deliveries.last
          expect(last_delivery.body.raw_source).to include I18n.t("activerecord.attributes.employer.packages.free")
        end
      end

      context "extend package" do
        before(:each) do
          @employer = FactoryBot.create(:employer, activated: true, package_booking_date: Date.today - 1.year)
        end

        it "updates package_booking_date" do
            get :extend_package, params: { id:@employer.id }
            @employer.reload
            expect(@employer.package_booking_date).to eq(Date.today)
        end

        it "sends one email to staff to confirm the extension of the package" do
            old_count = ActionMailer::Base.deliveries.count
            get :extend_package, params: { id:@employer.id }
            expect(ActionMailer::Base.deliveries.count).to eq(old_count + 1)
        end
      end
    end

    it "should not be accessible for staff members" do
      staff = FactoryBot.create(:staff)
      login staff.user
      get :activate, params: { id: FactoryBot.create(:employer).id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql(I18n.t('unauthorized.default'))
    end

    it "should not be accessible for students" do
      login student.user
      get :activate, params: { id: FactoryBot.create(:employer).id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql(I18n.t('unauthorized.default'))
    end

    it "should delete staff of an deleted employer" do
      employer = FactoryBot.create(:employer, activated: true)
      staff = FactoryBot.create(:staff, employer: employer)
      staff2 = FactoryBot.create(:staff, employer: employer)
      job_offer = FactoryBot.create(:job_offer, employer: employer)
      student = FactoryBot.create(:student)
      expect {
        delete :destroy, params: { id: employer.id }
        }.to change(Employer, :count).by(-1) and change(Staff, :count).by(-2) and change(JobOffer, :count).by(-1)
    end
  end

  describe "GET deactivate" do
    context "as an admin" do
      before(:each) do
        login admin
      end

      it "deactivates the employer" do
        get :deactivate, params: { id: employer.id }
        expect(employer.reload.activated).to eq(false)
      end

      it "sets the free package as booked package" do
        employer = FactoryBot.create(:employer, :premium)
        expect(employer.booked_package_id).to eq(Employer::PACKAGES.index('premium'))
        get :deactivate, params: { id: employer.id }
        expect(employer.reload.booked_package_id).to eq(Employer::PACKAGES.index('free'))
      end

      it "redirects to employer" do
        get :deactivate, params: { id: employer.id }
        expect(response).to redirect_to(employer)
      end

      it "displays a success message" do
        get :deactivate, params: { id: employer.id }
        expect(flash[:success]).to eq(I18n.t('employers.messages.successfully_deactivated'))
      end
    end

    context "as a staff member" do
      before(:each) do
        login staff.user
      end

      it "redirects to employers index" do
        get :deactivate, params: { id: employer.id }
        expect(response).to redirect_to(root_path)
      end

      it "doesn't deactivate the employer" do
        get :deactivate, params: { id: employer.id }
        expect(employer.reload.activated).to eq(true)
      end
    end

    context "as a student" do
      before(:each) do
        login student.user
      end

      it "redirects to employers index" do
        get :deactivate, params: { id: employer.id }
        expect(response).to redirect_to(root_path)
      end

      it "doesn't deactivate the employer" do
        get :deactivate, params: { id: employer.id }
        expect(employer.reload.activated).to eq(true)
      end
    end
  end

  describe "POST invite_colleague" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    context "as a staff member" do
      before(:each) do
        login employer.staff_members.first.user
      end

      it "redirects to employer" do
        post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann" } }
        expect(response).to redirect_to(employer_path(employer))
      end

      it "sends invitation mail to colleague" do
        post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann" } }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to[0]).to eq('test@test.de')
      end

      context "when email is blank" do
        it "redirects to employer" do
          post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "", first_name: "Max", last_name: "Mustermann" } }
          expect(response).to redirect_to(employer_path(employer))
        end

        it "displays notice" do
          post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "", first_name: "Max", last_name: "Mustermann" } }
          expect(flash[:notice]).to eq(I18n.t('employers.messages.invalid_colleague_email'))
        end

        it "doesn't send invitation mail" do
          expect {
            post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "", first_name: "Max", last_name: "Mustermann" } }
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end

    context "as a student" do
      before(:each) do
        login student.user
      end

      it "redirects to employers index" do
        post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "", first_name: "Max", last_name: "Mustermann" } }
        expect(response).to redirect_to(root_path)
      end

      it "doesn't send mail" do
        post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann" } }
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context "when logged out" do
      before(:each) do
        logout
      end

      it "doesn't send mail" do
        login FactoryBot.create(:student).user
        post :invite_colleague, params: { id: employer.id, invite_colleague_email: { colleague_email: "test@test.de", first_name: "Max", last_name: "Mustermann" } }
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end

  describe "POST send_csv" do
    it "should send a CSV file to an admin" do
      login admin
      post :send_csv
      expect(response.headers['Content-Type']).to eq "text/csv"
    end

    it "calls Employer.export with specified time span" do
      login admin
      expect(Employer).to receive(:export).with(Date.new(1970,1,1), Date.current)
      post :send_csv, params: { employers: 'registered_from_to', from_date: {day: 1, month: 1, year: 1970}, to_date: {day: Date.current.day, month: Date.current.month, year: Date.current.year} }
    end

    it "should not send a CSV to a student" do
      login student.user
      post :send_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql(I18n.t('unauthorized.default'))
    end

    it "should not send a CSV to a staff member" do
      login FactoryBot.create(:staff).user
      post :send_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql(I18n.t('unauthorized.default'))
    end
  end

  describe "DELETE destroy" do
    context "as an admin" do
      before(:each) do
        login admin
      end

      it "destroys the employer" do
        expect {
          delete :destroy, params: { id: employer.id }
        }.to change(Employer, :count).by(-1)
      end

      it "redirects to employers index" do
        delete :destroy, params: { id: employer.id }
        expect(response).to redirect_to(employers_path)
      end

      it "displays success message" do
        delete :destroy, params: { id: employer.id }
        expect(flash[:success]).to eq(I18n.t('employers.messages.successfully_deleted'))
      end

      context "if destroy fails" do
        before(:each) do
          allow(Employer).to receive(:find).and_return(employer)
          allow(employer).to receive(:destroy).and_return(false)
        end

        it "redirects to employer" do
          delete :destroy, params: { id: employer.id }
          expect(response).to redirect_to(employer)
        end

        it "displays an error message" do
          delete :destroy, params: { id: employer.id }
          expect(flash[:error]).to eq(I18n.t('employers.messages.unsuccessfully_deleted'))
        end
      end
    end
  end
end
