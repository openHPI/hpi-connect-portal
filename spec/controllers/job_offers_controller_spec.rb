# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

require 'rails_helper'

describe JobOffersController do
  let(:employer) { FactoryBot.create(:employer) }
  let!(:active_job_offer) { FactoryBot.create(:job_offer, title: 'Active Job Offer', employer: employer) }
  let!(:pending_job_offer) { FactoryBot.create(:job_offer, status: JobStatus.pending, title: 'Pending Job Offer', employer: employer) }
  let!(:closed_job_offer) { FactoryBot.create(:job_offer, status: JobStatus.closed, title: 'Closed Job Offer', employer: employer) }
  let(:staff) { FactoryBot.create(:staff, employer: employer) }
  let(:student) { FactoryBot.create(:student) }
  let(:admin) { FactoryBot.create(:user, :admin) }

  let(:valid_attributes) { { "title"=>"Open HPI Job", "description_en" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => JobStatus.active } }
  let(:valid_attributes_status_closed) {{"title"=>"Open HPI Job", "description_en" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => JobStatus.closed } }
   let(:valid_contact_attributes) { { contact_attributes: { "name"=>"Contact Me", "street"=>"Contact Street", "zip_city"=>"12345 Contact", "email"=>"contact@me.com" },
    "copy_to_employer_contact"=>"true" } }

  before(:each) do
    #login FactoryBot.create(:student).user

    #ActionMailer::Base.delivery_method = :test
    #ActionMailer::Base.perform_deliveries = true
    #ActionMailer::Base.deliveries = []

    #employer.reload
  end

  describe "GET index" do
    it "assigns active job_offers as @job_offers" do
      get :index, {}
      expect(assigns(:job_offers)).to eq(JobOffer.sort(JobOffer.active, 'date'))
    end

    it "renders the correct template" do
      get :index, {}
      expect(response).to render_template("index")
    end

    context "logged in as admin" do
      before(:each) do
        login admin
      end

      it "assigns all job offers as @job_offers if requested" do
        get :index, { pending: 'true' }
        expect(assigns(:job_offers)).to eq(JobOffer.sort(JobOffer.pending, 'date'))
      end
    end

    context "logged in as non-admin" do
      before(:each) do
        login staff.user
      end

      it "doesn't assign all job offers as @job_offers even if requested" do
        get :index, { pending: 'true' }
        expect(assigns(:job_offers)).to eq(JobOffer.sort(JobOffer.active, 'date'))
        expect(assigns(:job_offers)).not_to eq(JobOffer.sort(JobOffer.pending, 'date'))
      end
    end

    context "when creating a newsletter" do
      before(:each) do
        login student.user
      end

      it "redirects to newsletter_orders#new" do
        get :index, { commit: I18n.t("job_offers.create_as_newsletter") }
        expect(response).to redirect_to(new_newsletter_order_path({ newsletter_params: { active: true } }))
      end
    end

    context "searching job offers" do
      let!(:a_job_offer) { FactoryBot.create(:job_offer) }
      let!(:job_offer_with_different_employer) { FactoryBot.create(:job_offer) }
      let(:different_employer) { job_offer_with_different_employer.employer }

      it "assigns all job offers with the specified employer to @job_offers" do
        get :index, ({ employer: different_employer.id })
        expect(assigns(:job_offers)).to include(job_offer_with_different_employer)
        expect(assigns(:job_offers)).not_to include(a_job_offer)
        expect(assigns(:job_offers)).to eq(JobOffer.filter_employer(different_employer.id))
      end
    end
  end

  describe "GET archive" do
    before(:each) do
      login student.user
    end

    it "assigns all closed job offers as @job_offers" do
      get :archive
      expect(assigns(:job_offers)).to eq(JobOffer.closed)
    end
  end

  describe "GET show" do
    context "as a student" do
      before(:each) do
        login student.user
      end

      it "assigns the requested job_offer as @job_offer" do
        get :show, { id: active_job_offer.id }
        expect(assigns(:job_offer)).to eq(active_job_offer)
      end

      it "redirects to archive if job is closed" do
        get :show, { id: closed_job_offer.id }
        expect(response).to redirect_to(archive_job_offers_path)
      end
    end

    context "as an admin" do
      before(:each) do
        login admin
      end

      it "shows closed jobs" do
        get :show, { id: closed_job_offer.id }
        expect(response).not_to redirect_to(archive_job_offers_path)
        expect(response).to render_template("show")
      end
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      login staff.user
      get :new
      expect(assigns(:job_offer)).to be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      login staff.user
      get :edit, { id: active_job_offer.id }
      expect(assigns(:job_offer)).to eq(active_job_offer)
    end
  end

  describe "GET matching" do
    let(:programming_language1) { FactoryBot.create(:programming_language) }
    let(:programming_language2) { FactoryBot.create(:programming_language) }
    let(:programming_language3) { FactoryBot.create(:programming_language) }
    let(:language1) { FactoryBot.create(:language) }
    let(:language2) { FactoryBot.create(:language) }
    let(:skilled_student) { FactoryBot.create(:student, programming_languages: [programming_language1, programming_language2], languages: [language1]) }
    let(:language_ids) { skilled_student.languages.map(&:id) }
    let(:programming_language_ids) { skilled_student.programming_languages.map(&:id) }
    let!(:matching_job1) { FactoryBot.create(:job_offer, languages: [language1], programming_languages: [programming_language2]) }
    let!(:matching_job2) { FactoryBot.create(:job_offer, languages: [language1], programming_languages: [programming_language1]) }
    let!(:non_matching_job1) { FactoryBot.create(:job_offer, programming_languages: [programming_language1, programming_language2]) }
    let!(:non_matching_job2) { FactoryBot.create(:job_offer, languages: [language2], programming_languages:[programming_language3]) }

    before(:each) do
      login skilled_student.user
    end

    it "assigns all job offers that match the current user to @job_offer" do
      get :matching, { language_ids: language_ids, programming_language_ids: programming_language_ids }
      expect(assigns(:job_offers)).to include(matching_job1, matching_job2)
      expect(assigns(:job_offers)).not_to include(non_matching_job1, non_matching_job2)
      expect(assigns(:job_offers)).to eq(JobOffer.sort(JobOffer.filter_languages(language_ids).filter_programming_languages(programming_language_ids), 'date'))
    end
  end

  describe "PUT prolong" do
    before(:each) do
      @job_offer = FactoryBot.create(:job_offer, status: JobStatus.active)
      @staff = FactoryBot.create(:staff, employer: @job_offer.employer)
      @job_offer.update({end_date: Date.current + 10 })
      login @staff.user
    end

    it "should not immediately prolong the job once" do
      get :request_prolong, {id: @job_offer.id}
      expect(response).to redirect_to(@job_offer)
      expect(assigns(:job_offer).prolonged_at).to eq(nil)
      expect(assigns(:job_offer).prolong_requested).to eq(true)
    end

    it "should not be possible to request for the staff of another employer" do
      login FactoryBot.create(:staff).user
      get :request_prolong, {id: @job_offer.id}
      expect(response).to redirect_to(job_offers_path)
    end

    it "should not be possible to prolong for a staff member" do
      get :prolong, {id: @job_offer.id}
      expect(response).to redirect_to(job_offers_path)
    end

    it "should only be possible for an admin" do
      login FactoryBot.create(:user, :admin)
      get :prolong, {id: @job_offer.id}
      expect(response).to redirect_to(@job_offer)
      expect(assigns(:job_offer).prolonged_at).to eq(Date.current)
    end
  end

  describe "GET close" do
    context "as a staff member" do
      before(:each) do
        login staff.user
      end

      it "changes the job offer status to closed" do
        get :close, { id: active_job_offer.id }
        expect(active_job_offer.reload.status).to eq(JobStatus.closed)
      end

      it "re-renders the edit template if update fails" do
        allow_any_instance_of(JobOffer).to receive(:update).and_return(false)
        get :close, { id: active_job_offer.id }
        expect(response).to render_template('edit')
      end
    end

    context "as a staff member of another employer" do
      before(:each) do
        login FactoryBot.create(:staff).user
      end

      it "doesn't change the job offer status" do
        get :close, { id: active_job_offer.id }
        expect(active_job_offer.reload.status).to eq(JobStatus.active)
      end

      it "redirects to the job offer" do
        get :close, { id: active_job_offer.id }
        expect(response).to redirect_to(active_job_offer)
      end
    end
  end

  describe "GET accept" do
    let!(:job_offer) { FactoryBot.create(:job_offer, :graduate_job, status: JobStatus.pending) }

    context "as a user who isn't admin" do
      before(:each) do
        login student.user
      end

      it "leaves the job offer pending" do
        expect(job_offer.status).to eq(JobStatus.pending)
        expect {
          get :accept, { id: job_offer.id }
        }.to_not change(job_offer, :status)
      end

      it "redirects to job offer index path" do
        get :accept, { id: job_offer.id }
        expect(response).to redirect_to(job_offers_path)
      end
    end

    context "as an admin" do
      before(:each) do
        login admin
        ActionMailer::Base.deliveries = []
      end

      it "sends an email to all staff members" do
        get :accept, { id: job_offer.id }
        expect(ActionMailer::Base.deliveries.count).to eq(job_offer.employer.staff_members.length)
      end

      it "changes the job offer status to active" do
        get :accept, { id: job_offer.id }
        expect(job_offer.reload.status).to eq(JobStatus.active)
      end

      it "redirects to the job offer page" do
        get :accept, { id: job_offer.id }
        expect(response).to redirect_to(job_offer)
      end

      it "sets the release date when job offer is accepted" do
        expect(job_offer.release_date).not_to eq(Date.current)
        get :accept, { id: job_offer.id }
        expect(job_offer.reload.release_date).to eq(Date.current)
      end

      it "redirects to job offer page if update fails" do
        allow(JobOffer).to receive(:find).and_return(job_offer)
        allow(job_offer).to receive(:update).and_return(false)
        get :accept, { id: job_offer.id }
        expect(response).to redirect_to(job_offer)
      end
    end
  end

  describe "GET decline" do
    let!(:job_offer) { FactoryBot.create(:job_offer, :graduate_job) }

    context "as a user who isn't admin" do
      before(:each) do
        login student.user
      end

      it "prohibits user to decline job offers" do
        get :decline, { id: job_offer.id }
        expect(response).to redirect_to(job_offer)
      end
    end

    context "as an admin" do
      before :each do
        login admin
      end

      it "destroys the job offer" do
        expect {
          get :decline, { id: job_offer.id }
        }.to change(JobOffer, :count).by(-1)
      end

      it "redirects to the job offer index page" do
        get :decline, { id: job_offer.id }
        expect(response).to redirect_to(job_offers_path)
      end

      it "decrements request counter for employer" do
        expect(job_offer.employer.single_jobs_requested).to eq 0
        expect {
          get :decline, { id: job_offer.id }
        }.to change{ job_offer.employer.reload.single_jobs_requested }.by(-1)
      end

      it "redirects to job offer page if destroy fails" do
        allow(JobOffer).to receive(:find).and_return(job_offer)
        allow(job_offer).to receive(:destroy).and_return(false)
        get :decline, { id: job_offer.id }
        expect(response).to redirect_to(job_offer)
      end
    end
  end

  describe "GET reopen" do
    context "with valid params" do
      let!(:job_offer) { FactoryBot.create(:job_offer, :graduate_job, status: JobStatus.closed) }
      let(:staff) { job_offer.employer.staff_members.first }

      before(:each) do
        login staff.user
      end

      it "assigns a new job_offer as @job_offer" do
        get :reopen, {id: job_offer.id}
        expect(assigns(:job_offer)).to be_a_new(JobOffer)
        expect(response).to render_template("new")
      end

      it "has same values as the original job offer" do
        get :reopen, {id: job_offer.id}
        reopened_job_offer = assigns(:job_offer)
        expected_attr = ["description_de", "description_en", "title", "time_effort", "compensation", "employer_id", "category_id", "graduation_id", "student_group_id"]
        expected_contact_attr = ["name", "street", "zip_city", "email", "phone"]

        expect(reopened_job_offer.attributes.slice(*expected_attr)).to eql(job_offer.attributes.slice(*expected_attr))
        expect(reopened_job_offer.contact.attributes.slice(*expected_contact_attr)).to eql(job_offer.contact.attributes.slice(*expected_contact_attr))
        expect(reopened_job_offer.start_date).to be_nil
        expect(reopened_job_offer.end_date).to be_nil
      end

      it "old job offer status changes to closed" do
        get :reopen, {id: job_offer.id}
        expect(job_offer.reload.status).to eql(JobStatus.closed)
      end

      it "redirects to job offer page if update fails" do
        allow(JobOffer).to receive(:find).and_return(job_offer)
        allow(job_offer).to receive(:update).and_return(false)
        get :reopen, { id: job_offer.id }
        expect(response).to redirect_to(job_offer)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      login staff.user
    end

    describe "with valid params" do
      it "allows staff members to create a new job offer" do
        expect {
          post :create, {job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(1)
        expect(response).to redirect_to job_offer_path(JobOffer.last)
      end

      it "allows the admin to create a new job offer" do
        login FactoryBot.create(:user, :admin)
        expect {
          post :create, { job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(1)
        expect(response).to redirect_to job_offer_path(JobOffer.last)
      end

      it "doesn't allow students to create a job offer" do
        login FactoryBot.create(:student).user
        expect {
          post :create, {job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(0)
        expect(response).to redirect_to job_offers_path
      end

      it "creates a new job_offer" do
        expect {
          post :create, {job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {job_offer: valid_attributes}
        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {job_offer: valid_attributes}
        expect(response).to redirect_to(JobOffer.last)
      end

      it "automatically assigns the users employer as the new job offers employer" do
        post :create, {job_offer: valid_attributes}
        offer = JobOffer.last
        expect(offer.employer).to eq(staff.employer)
      end

      it "automatically converts 'Haustarif'" do
        attributes = valid_attributes
        attributes["compensation"] = I18n.t('job_offers.default_compensation')

        post :create, {job_offer: attributes}
        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
        offer = JobOffer.last
        assert_equal(offer.compensation, 10.0)
      end

      it "automatically converts 'ab sofort' as a start date" do
        attributes = valid_attributes
        attributes["start_date"] = I18n.t('job_offers.default_startdate')

        expect{
          post :create, {job_offer: attributes}
        }.to change(JobOffer, :count).by(1)

        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
        offer = JobOffer.last
        assert_equal(offer.start_date, Date.current + 1)
        assert_equal(offer.flexible_start_date, true)
      end

      it "does create a pending joboffer if employer is deactivated" do
        staff = FactoryBot.create :staff
        staff.employer.update_column :activated, false
        login staff.user
        expect {
          post :create, {job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(1)
        expect(assigns(:job_offer).status).to eq(JobStatus.pending)
      end

      it "copies contact address to employer if parameter is set" do
        attributes = valid_attributes.merge(valid_contact_attributes)

        expect{
          post :create, { job_offer: attributes }
        }.to change(JobOffer, :count).by(1)

        expect(staff.employer.contact.reload.name).to eq(attributes[:contact_attributes]["name"])
        expect(staff.employer.contact.street).to eq(attributes[:contact_attributes]["street"])
        expect(staff.employer.contact.zip_city).to eq(attributes[:contact_attributes]["zip_city"])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        post :create, {job_offer: { "description" => "invalid value" }}
        expect(assigns(:job_offer)).to be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        expect {
          post :create, {job_offer: valid_attributes}
        }.to change(JobOffer, :count).by(0)
        expect(response).to render_template("new")
      end

      it "should not send mail to admin" do
        job_offer = FactoryBot.create(:job_offer)
        #expect
        expect(JobOffersMailer).not_to receive(:new_job_offer_email).with( job_offer )
        # when
        FactoryBot.create(:job_offer)
      end

      it "handles an invalid start date" do
        attributes = valid_attributes
        attributes["start_date"] = '20-40-2014'

        expect {
          post :create, {job_offer: attributes}
        }.to change(JobOffer, :count).by(0)
        expect(response).to render_template("new")
      end
    end

    describe "for employers" do
      before :each do
        @employer = FactoryBot.create(:employer)
        @staff = FactoryBot.create(:staff, employer: @employer)
        @attributes = valid_attributes
        @attributes["category_id"] = 2
        @attributes["employer_id"] = @employer.id
      end

      it "should be possible to create a graduate job with the free or profile package" do
        ActionMailer::Base.deliveries = []
        login @staff.user
        expect {
          post :create, {job_offer: @attributes}
        }.to change(JobOffer, :count).by(1)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        email = ActionMailer::Base.deliveries[0]
        assert_equal(email.to, [Configurable.mailToAdministration])
        #response.should render_template("new")

        ActionMailer::Base.deliveries = []
        @employer.update_column :booked_package_id, 1
        expect {
          post :create, {job_offer: @attributes}
        }.to change(JobOffer, :count).by(1)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        email = ActionMailer::Base.deliveries[0]
        assert_equal(email.to, [Configurable.mailToAdministration])
        #response.should render_template("new")
      end

      it "should only be possible to create 4 graduate job with the partner package" do
        @employer.update_column :booked_package_id, 2
        login @staff.user
        assert_equal(0, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        4.times do
          expect {
            post :create, {job_offer: @attributes}
          }.to change(JobOffer, :count).by(1)
        end
        assert_equal(0, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        expect {
          post :create, {job_offer: @attributes}
        }.to change(JobOffer, :count).by(1)
        assert_equal(1, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        #response.should render_template("new")
      end

      it "should be possible to create 20 graduate job with the premium package" do
        @employer.update_column :booked_package_id, 3
        login @staff.user
        assert_equal(0, @employer.single_jobs_requested)
        20.times do
          expect {
            post :create, {job_offer: @attributes}
          }.to change(JobOffer, :count).by(1)
        end
        assert_equal(0, @employer.single_jobs_requested)
        expect {
          post :create, {job_offer: @attributes}
        }.to change(JobOffer, :count).by(1)
        assert_equal(1, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        #assert_equal(flash[:success], I18n.t('employers.messages.successfully_created.'))
        #response.should render_template("new")

      end
    end
  end

  describe "PUT update" do
    context "as a staff member" do
      before(:each) do
        login staff.user
      end

      context "with valid params" do
        it "updates the requested job offer" do
          expect_any_instance_of(JobOffer).to receive(:update).with({ "description_en" => "New and shiny description." })
          put :update, { id: active_job_offer.id, job_offer: { "description_en" => "New and shiny description." } }
        end

        it "updates the job offer's attributes" do
          put :update, { id: active_job_offer.id, job_offer: { "description_en" => "New and shiny description." } }
          expect(active_job_offer.reload.description_en).to eq("New and shiny description.")
        end

        it "assigns the requested job_offer as @job_offer" do
          put :update, { id: active_job_offer.id, job_offer: valid_attributes }
          expect(assigns(:job_offer)).to eq(active_job_offer)
        end

        it "redirects to the job_offer" do
          put :update, {id: active_job_offer.to_param, job_offer: valid_attributes}
          expect(response).to redirect_to(active_job_offer)
        end
      end

      context "with invalid params" do
        it "re-renders the edit form" do
          allow_any_instance_of(JobOffer).to receive(:update).and_return(false)
          put :update, { id: active_job_offer.id, job_offer: { "description" => "invalid value" } }
          expect(response).to render_template('edit')
        end
      end

      context "with copy_to_employer_contact set" do
        it "updates the employer's contact" do
          expect_any_instance_of(Contact).to receive(:update).with(valid_contact_attributes[:contact_attributes])
          put :update, { id: active_job_offer.id, job_offer: valid_contact_attributes }
        end

        it "updates the employer's contact attributes" do
          put :update, { id: active_job_offer.id, job_offer: valid_contact_attributes }
          expect(active_job_offer.employer.contact.reload.name).to eq(valid_contact_attributes[:contact_attributes]['name'])
        end
      end

      context "with a closed job offer" do
        it "updates the job offer's attributes" do
          put :update, { id: closed_job_offer.id, job_offer: { "description_en" => "New and shiny description." } }
          expect(closed_job_offer.reload.description_en).not_to eq("New and shiny description.")
        end

        it "redirects to the job_offer" do
          put :update, {id: closed_job_offer.to_param, job_offer: valid_attributes}
          expect(response).to redirect_to(closed_job_offer)
        end
      end
    end

    context "as a staff member of another employer" do
      before(:each) do
        login FactoryBot.create(:staff).user
      end

      it "doesn't update attributes" do
        put :update, { id: active_job_offer.id, job_offer: { "description_en" => "New and shiny description." } }
        expect(active_job_offer.reload.description_en).not_to eq("New and shiny description.")
      end

      it "redirects to job offer" do
        put :update, { id: active_job_offer.id, job_offer: { "description_en" => "New and shiny description." } }
        expect(response).to redirect_to(active_job_offer)
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      login staff.user
    end

    context "with an active job offer" do
      it "keeps the job offer" do
        expect {
          delete :destroy, { id: active_job_offer.id }
        }.to change(JobOffer, :count).by(0)
        expect(response).to redirect_to(active_job_offer)
      end

      it "redirects to the job offer page" do
        delete :destroy, { id: active_job_offer.id }
        expect(response).to redirect_to(active_job_offer)
      end
    end

    context "with a pending job offer" do
      it "destroys the requested job_offer" do
        expect {
          delete :destroy, { id: pending_job_offer.id }
        }.to change(JobOffer, :count).by(-1)
      end

      it "redirects to the job_offers list" do
        delete :destroy, { id: pending_job_offer.id }
        expect(response).to redirect_to(job_offers_url)
      end
    end
  end

  describe "GET export" do
    it "should send a CSV file to an admin user" do
      login admin
      get :export
      expect(response.headers['Content-Type']).to eq 'text/csv'
    end

    it "should not send a CSV file to a non-admin user" do
      login FactoryBot.create(:user)
      get :export
      expect(response).to redirect_to(job_offers_path)
      expect(flash[:notice]).to eql(I18n.t('unauthorized.default'))
    end
  end
end
