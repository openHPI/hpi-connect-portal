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

  before(:each) do
    login FactoryGirl.create(:student).user
  end
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:employer) { FactoryGirl.create(:employer) }
  let(:staff) { FactoryGirl.create(:staff, employer: employer) }
  let(:closed) {FactoryGirl.create(:job_status, :closed)}
  let(:valid_attributes) {{ "title"=>"Open HPI Job", "description_en" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :active)}}
  let(:valid_attributes_status_closed) {{"title"=>"Open HPI Job", "description_en" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => closed}}
  let(:valid_attributes_status_active) {{"title"=>"Open HPI Job", "description_en" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
   "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :active)}}

  let(:valid_session) { {} }

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  before(:each) do
    @epic = FactoryGirl.create(:employer)
    @os = FactoryGirl.create(:employer)
    @itas = FactoryGirl.create(:employer)

    @employer_one = FactoryGirl.create(:employer)
    @employer_two = FactoryGirl.create(:employer)
    @employer_three = FactoryGirl.create(:employer)

    @active = FactoryGirl.create(:job_status, name:"active")
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @job_offer = FactoryGirl.create(:job_offer, status: @active)

    employer.reload
  end

  describe "Check if views are rendered" do
    render_views

    it "renders the find results" do
      get :index, ({ employer: employer.id }), valid_session
      expect(response).to render_template("index")
    end

    it "renders the archive" do
      get :archive, {}, valid_session
      expect(response).to render_template("archive")
    end

    it "renders the jobs found archive" do
      get :archive, ({search: "Ruby"}), valid_session
      expect(response).to render_template("archive")
    end
  end

  describe "GET index" do
    it "assigns all job_offers as @job_offers_list[:items]" do
      get :index, {}, valid_session
      expect(assigns(:job_offers_list)[:items]).to eq([@job_offer])
    end
  end

  describe "GET archive" do
    it "assigns all archive job_offers as @job_offerlist[:items]" do
      @job_offer.update!(status: closed)
      get :archive, {}, valid_session
      expect(assigns(:job_offers_list)[:items]).to eq([@job_offer])
    end

    it "does not assign non-closed jobs" do
      get :archive, {}, valid_session
      assert assigns(:job_offers_list)[:items].empty?
    end
  end

  describe "GET show" do
    it "assigns the requested job_offer as @job_offer" do
      get :show, {id: @job_offer.to_param}, valid_session
      expect(assigns(:job_offer)).to eq(@job_offer)
    end

    it "redirects students when job is in archive" do
      archive_job = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: "closed"))
      get :show, {id: archive_job.to_param}, valid_session
      expect(response).to redirect_to(archive_job_offers_path)
    end

    it "shows archive job for admin" do
      login FactoryGirl.create(:user, :admin)

      archive_job = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: "closed"))
      get :show, {id: archive_job.to_param}, valid_session
      expect(response).not_to redirect_to(archive_job_offers_path)
      expect(response).to render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      login staff.user

      get :new, {}, valid_session
      expect(assigns(:job_offer)).to be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      get :edit, {id: @job_offer.to_param}, valid_session
      expect(assigns(:job_offer)).to eq(@job_offer)
    end
  end

  describe "GET find" do
    it "assigns @job_offers_list[:items] to all job offers with the specified employer" do

      FactoryGirl.create(:job_offer, employer: @employer_two, status: @active)
      FactoryGirl.create(:job_offer, employer: @employer_one, status: @active)
      FactoryGirl.create(:job_offer, employer: @employer_three, status: @active)
      FactoryGirl.create(:job_offer, employer: @employer_one, status: @active)

      job_offers = JobOffer.filter_employer(@employer_one.id)
      get :index, ({employer: @employer_one.id}), valid_session
      expect(assigns(:job_offers_list)[:items].to_a).to match_array((job_offers).to_a)
    end

    context "student selects student group" do

      subject(:hpi_group_id)     { Student.group_id("hpi") }
      subject(:dschool_group_id) { Student.group_id("dschool") }
      subject(:both_group_id)    { Student.group_id("both") }


      let!(:job_offers_hpi)     { [@job_offer] }
      let!(:job_offers_dschool) { FactoryGirl.create_list(:job_offer, 2, employer: @employer_two, status: @active, student_group_id:  dschool_group_id)}
      let!(:job_offers_both)    { FactoryGirl.create_list(:job_offer, 2, employer: @employer_three, status: @active, student_group_id: both_group_id)}


      context "student selects 'HPI' group" do
        it "assings all job offers tagged with 'HPI' and 'Both' group to @job_offers_list[:items]" do
          get :index, ({student_group: hpi_group_id}), valid_session
          expect(assigns(:job_offers_list)[:items].to_a).to match_array((job_offers_hpi | job_offers_both).to_a)
        end
      end

      context "student selects 'D-School' group" do
        it "assings all job offers tagged with with 'D-School' and 'Both' group to @job_offers_list[:items]" do
          get :index, ({student_group: dschool_group_id }), valid_session
          expect(assigns(:job_offers_list)[:items].to_a).to match_array((job_offers_dschool | job_offers_both).to_a)
        end
      end

      context "student selects blank" do
        it "assings all job offers tagged with 'HPI', 'D-School' and 'Both' group to @job_offers_list[:items]" do
          get :index, ({student_group: "" }), valid_session
          expect(assigns(:job_offers_list)[:items].to_a).to match_array((job_offers_hpi | job_offers_dschool | job_offers_both).to_a)
        end
      end
    end

  end

  describe "GET matching" do
    it "assigns @job_offers_list[:items] to all job offers matching to the logged in user" do
      programming_language1 = FactoryGirl.create(:programming_language)
      programming_language2 = FactoryGirl.create(:programming_language)
      programming_language3 = FactoryGirl.create(:programming_language)

      language1 = FactoryGirl.create(:language)
      language2 = FactoryGirl.create(:language)

      JobOffer.delete_all
      job1 = FactoryGirl.create(:job_offer, status: @active, languages: [language1], programming_languages: [programming_language2])
      job2 = FactoryGirl.create(:job_offer, status: @active, programming_languages: [programming_language1, programming_language2])
      job3 = FactoryGirl.create(:job_offer, status: @active, languages: [language1], programming_languages: [programming_language1] )
      job4 = FactoryGirl.create(:job_offer, status: @active, languages: [language2], programming_languages:[programming_language3])

      student = FactoryGirl.create(:student, programming_languages: [programming_language1, programming_language2], languages: [language1])
      login student.user
      get :matching, {language_ids: student.languages.map(&:id), programming_language_ids: student.programming_languages.map(&:id)}, valid_session
      items = assigns(:job_offers_list)[:items].to_a
      assert items.include? job1
      assert items.include? job3
    end
  end


  describe "PUT prolong" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :active))
      @staff = FactoryGirl.create(:staff, employer: @job_offer.employer)
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
      login FactoryGirl.create(:staff).user
      get :request_prolong, {id: @job_offer.id}
      expect(response).to redirect_to(job_offers_path)
    end

    it "should not be possible to prolong for a staff member" do
      get :prolong, {id: @job_offer.id}
      expect(response).to redirect_to(job_offers_path)
    end

    it "should only be possible for an admin" do
      login FactoryGirl.create(:user, :admin)
      get :prolong, {id: @job_offer.id}
      expect(response).to redirect_to(@job_offer)
      expect(assigns(:job_offer).prolonged_at).to eq(Date.current)
    end
  end

  describe "GET close" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :active))
    end

    it "marks jobs as completed if the user is staff of the employer" do
      closed = FactoryGirl.create(:job_status, :closed)
      login FactoryGirl.create(:staff, employer: @job_offer.employer).user

      get :close, { id: @job_offer.id }
      expect(assigns(:job_offer).status).to eq(closed)
    end
    it "prohibits user to mark jobs as completed if he is no staff of the employer" do
      get :close, { id: @job_offer.id}, valid_session
      expect(response).to redirect_to(@job_offer)
    end
  end

  describe "GET accept" do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, employer: employer, release_date: nil)
    end

    it "prohibits user to accept job offers if he is not the admin" do
      login @job_offer.employer.staff_members[0].user
      get :accept, { id: @job_offer.id }
      expect(assigns(:job_offer).status).to eq(JobStatus.pending)
      expect(response).to redirect_to(job_offers_path)
    end

    it "should send an email to all staff members" do
      login admin
      get :accept, { id: @job_offer.id }
      expect(ActionMailer::Base.deliveries.count).to eq(@job_offer.employer.staff_members.length)
    end

    it "accepts job offers" do
      login admin
      get :accept, {id: @job_offer.id}
      expect(assigns(:job_offer).status).to eq(JobStatus.active)
      expect(ActionMailer::Base.deliveries.count).to be >= 1
      expect(response).to redirect_to(@job_offer)
    end

    it "sets the release date when job offer is accepted" do
      login admin
      expect(@job_offer.release_date).to eq(nil)
      get :accept, {id: @job_offer.id}
      expect(assigns(:job_offer).release_date).not_to eq(nil)
    end
  end

  describe "GET decline" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, employer: employer)
    end

    it "prohibits user to decline job offers if he is not the admin" do
      get :decline, {id: @job_offer.id}
      expect(response).to redirect_to(@job_offer)
    end

    it "declines job offers" do
      login admin
      expect {
        get :decline, {id: @job_offer.id}
      }.to change(JobOffer, :count).by(-1)
      expect(response).to redirect_to(job_offers_path)
    end
  end

  describe "GET reopen" do
    describe "with valid params" do

      before(:each) do
        login staff.user
        @job_offer = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :active))
      end

      it "assigns a new job_offer as @job_offer" do
        get :reopen, {id: @job_offer}, valid_session
        expect(assigns(:job_offer)).to be_a_new(JobOffer)
        expect(response).to render_template("new")
      end

      it "has same values as the original job offer" do
        get :reopen, {id: @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        expected_attr = [:description, :title, :time_effort, :compensation, :employer_id]

        expect(reopend_job_offer.attributes.with_indifferent_access.slice(expected_attr)).to eql(@job_offer.attributes.with_indifferent_access.slice(expected_attr))
        expect(reopend_job_offer.start_date).to be_nil
        expect(reopend_job_offer.end_date).to be_nil
      end

      it "is pending and old job offer changes to closed" do
        get :reopen, {id: @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        expect(@job_offer.reload.status).to eql(closed)
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
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        expect(response).to redirect_to job_offer_path(JobOffer.last)
      end

      it "allows the admin to create a new job offer" do
        login FactoryGirl.create(:user, :admin)
        expect {
          post :create, { job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        expect(response).to redirect_to job_offer_path(JobOffer.last)
      end

      it "doesn't allow students to create a job offer" do
        login FactoryGirl.create(:student).user
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        expect(response).to redirect_to job_offers_path
      end

      it "creates a new job_offer" do
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {job_offer: valid_attributes}, valid_session
        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {job_offer: valid_attributes}, valid_session
        expect(response).to redirect_to(JobOffer.last)
      end

      it "automatically assigns the users employer as the new job offers employer" do
        post :create, {job_offer: valid_attributes}, valid_session
        offer = JobOffer.last
        expect(offer.employer).to eq(staff.employer)
      end

      it "automatically converts 'Haustarif'" do
        attributes = valid_attributes
        attributes["compensation"] = I18n.t('job_offers.default_compensation')

        post :create, {job_offer: attributes}, valid_session
        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
        offer = JobOffer.last
        assert_equal(offer.compensation, 10.0)
      end

      it "automatically converts 'ab sofort' as a start date" do
        attributes = valid_attributes
        attributes["start_date"] = I18n.t('job_offers.default_startdate')

        expect{
          post :create, {job_offer: attributes}, valid_session
        }.to change(JobOffer, :count).by(1)

        expect(assigns(:job_offer)).to be_a(JobOffer)
        expect(assigns(:job_offer)).to be_persisted
        offer = JobOffer.last
        assert_equal(offer.start_date, Date.current + 1)
        assert_equal(offer.flexible_start_date, true)
      end

      it "does create a pending joboffer if employer is deactivated" do
        staff = FactoryGirl.create :staff
        staff.employer.update_column :activated, false
        login staff.user
                expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        expect(assigns(:job_offer).status).to eq(JobStatus.pending)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        post :create, {job_offer: { "description" => "invalid value" }}, valid_session
        expect(assigns(:job_offer)).to be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        expect(response).to render_template("new")
      end

      it "should not send mail to admin" do
        job_offer = FactoryGirl.create(:job_offer)
        #expect
        expect(JobOffersMailer).not_to receive(:new_job_offer_email).with( job_offer, valid_session )
        # when
        FactoryGirl.create(:job_offer)
      end

      it "handles an invalid start date" do
        attributes = valid_attributes
        attributes["start_date"] = '20-40-2014'

        expect {
          post :create, {job_offer: attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        expect(response).to render_template("new")
      end
    end

    describe "for employers" do

      before :each do
        @employer = FactoryGirl.create(:employer)
        @staff = FactoryGirl.create(:staff, employer: @employer)
        @attributes = valid_attributes
        @attributes["category_id"] = 2
        @attributes["employer_id"] = @employer.id
      end

      it "should be possible to create a graduate job with the free or profile package" do
        ActionMailer::Base.deliveries = []
        login @staff.user
        expect {
          post :create, {job_offer: @attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        email = ActionMailer::Base.deliveries[0]
        assert_equal(email.to, [Configurable.mailToAdministration])
        #response.should render_template("new")

        ActionMailer::Base.deliveries = []
        @employer.update_column :booked_package_id, 1
        expect {
          post :create, {job_offer: @attributes}, valid_session
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
            post :create, {job_offer: @attributes}, valid_session
          }.to change(JobOffer, :count).by(1)
        end
        assert_equal(0, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        expect {
          post :create, {job_offer: @attributes}, valid_session
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
            post :create, {job_offer: @attributes}, valid_session
          }.to change(JobOffer, :count).by(1)
        end
        assert_equal(0, @employer.single_jobs_requested)
        expect {
          post :create, {job_offer: @attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        assert_equal(1, (Employer.find @attributes["employer_id"]).single_jobs_requested)
        #assert_equal(flash[:success], I18n.t('employers.messages.successfully_created.'))
        #response.should render_template("new")

      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      login @job_offer.employer.staff_members[0].user
    end

    describe "with valid params" do
      it "updates the requested job_offer" do
        expect_any_instance_of(JobOffer).to receive(:update).with({ "description_en" => "MyString" })
        put :update, {id: @job_offer.to_param, job_offer: { "description_en" => "MyString" }}, valid_session
      end

      it "redirects to the job_offer page if the job is already running" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        expect(response).to redirect_to(@job_offer)
      end

      it "assigns the requested job_offer as @job_offer" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        expect(assigns(:job_offer)).to eq(@job_offer)
      end

      it "redirects to the job_offer" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        expect(response).to redirect_to(@job_offer)
      end

      it "only allows the responsible user to update" do
        login FactoryGirl.create(:staff, employer: @job_offer.employer).user
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        expect(response).to redirect_to(@job_offer)
      end
    end

    describe "with invalid params" do
      it "assigns the job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        put :update, {id: @job_offer.to_param, job_offer: { "description" => "invalid value" }}, valid_session
        expect(assigns(:job_offer)).to eq(@job_offer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(JobOffer).to receive(:save).and_return(false)
        put :update, {id: @job_offer.to_param, job_offer: { "description" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      login @job_offer.employer.staff_members[0].user
    end

    it "destroys the requested job_offer" do
      expect {
        delete :destroy, {id: @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(-1)
    end

    it "redirects to the job_offers list" do
      delete :destroy, {id: @job_offer.to_param}, valid_session
      expect(response).to redirect_to(job_offers_url)
    end

    it "redirects to the job offer page and keeps the offer if the job is running" do
      @job_offer.update!(status: FactoryGirl.create(:job_status, :active))
      login @job_offer.employer.staff_members[0].user

      expect {
        delete :destroy, {id: @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(0)
      expect(response).to redirect_to(@job_offer)
    end
  end
end
