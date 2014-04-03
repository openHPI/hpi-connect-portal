require 'spec_helper'

describe JobOffersController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  let(:assigned_student) { FactoryGirl.create(:student) }
  let(:employer) { FactoryGirl.create(:employer) }
  let(:responsible_user) { FactoryGirl.create(:staff, employer: employer) }
  let(:completed) {FactoryGirl.create(:job_status, :completed)}
  let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :open), "responsible_user_id" => responsible_user.id, "vacant_posts" => 1 } }
  let(:valid_attributes_status_running) {{"title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :running), "assigned_students" => [assigned_student], "responsible_user_id" => responsible_user.id, "vacant_posts" => 1 }}
  let(:valid_attributes_status_completed) {{"title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => completed, "assigned_students" => [assigned_student], "responsible_user_id" => responsible_user.id, "vacant_posts" => 1 }}

  let(:valid_session) { {} }

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
  end

  before(:each) do
    @epic = FactoryGirl.create(:employer)
    @os = FactoryGirl.create(:employer)
    @itas = FactoryGirl.create(:employer)

    @employer_one = FactoryGirl.create(:employer)
    @employer_two = FactoryGirl.create(:employer)
    @employer_three = FactoryGirl.create(:employer)

    @open = FactoryGirl.create(:job_status, name:"open")
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @job_offer = FactoryGirl.create(:job_offer, status: @open)

    employer.deputy.update_column :employer_id, employer.id
  end

  describe "Check if views are rendered" do
    render_views

    it "renders the find results" do
      get :index, ({ employer: employer.id }), valid_session
      response.should render_template("index")
    end

    it "renders the archive" do
      get :archive, {}, valid_session
      response.should render_template("archive")
    end

    it "renders the jobs found archive" do
      get :archive, ({:search => "Ruby"}), valid_session
      response.should render_template("archive")
    end
  end

  describe "GET index" do
    it "assigns all job_offers as @job_offers_list[:items]" do
      get :index, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([@job_offer])
    end
  end

  describe "GET archive" do
    it "assigns all archive job_offers as @job_offerlist[:items]" do
      @job_offer.update!(status: completed)
      get :archive, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([@job_offer])
    end

    it "does not assign non-completed jobs" do
      get :archive, {}, valid_session
      assert assigns(:job_offers_list)[:items].empty?
    end
  end

  describe "GET show" do
    it "assigns the requested job_offer as @job_offer" do
      get :show, {id: @job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(@job_offer)
    end

    it "assigns a possible applications as @application" do
      student = FactoryGirl.create(:student)
      login student.user

      application = FactoryGirl.create(:application, student: student, job_offer: @job_offer)
      get :show, {id: @job_offer.to_param}, valid_session
      assigns(:application).should eq(application)
    end

    it "redirects students when job is in archive" do
      archive_job = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: "completed"))
      get :show, {id: archive_job.to_param}, valid_session
      response.should redirect_to(archive_job_offers_path)
    end

    it "shows archive job for admin" do
      login FactoryGirl.create(:user, :admin)

      archive_job = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: "completed"))
      get :show, {id: archive_job.to_param}, valid_session
      response.should_not redirect_to(archive_job_offers_path)
      response.should render_template("show")
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      login responsible_user.user

      get :new, {}, valid_session
      assigns(:job_offer).should be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      get :edit, {id: @job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(@job_offer)
    end

    it "only allows the responsible user to edit" do
      login FactoryGirl.create(:staff).user
      get :edit, {id: @job_offer.to_param}, valid_session
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET find" do
    it "assigns @job_offers_list[:items] to all job offers with the specified employer" do

      FactoryGirl.create(:job_offer, employer: @employer_two, status: @open)
      FactoryGirl.create(:job_offer, employer: @employer_one, status: @open)
      FactoryGirl.create(:job_offer, employer: @employer_three, status: @open)
      FactoryGirl.create(:job_offer, employer: @employer_one, status: @open)

      job_offers = JobOffer.filter_employer(@employer_one.id)
      get :index, ({:employer => @employer_one.id}), valid_session
      assigns(:job_offers_list)[:items].to_a.should =~ (job_offers).to_a
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
      job1 = FactoryGirl.create(:job_offer, status: @open, languages: [language1], programming_languages: [programming_language2])
      job2 = FactoryGirl.create(:job_offer, status: @open, programming_languages: [programming_language1, programming_language2])
      job3 = FactoryGirl.create(:job_offer, status: @open, languages: [language1], programming_languages: [programming_language1] )
      job4 = FactoryGirl.create(:job_offer, status: @open, languages: [language2], programming_languages:[programming_language3])

      student = FactoryGirl.create(:student, programming_languages: [programming_language1, programming_language2], languages: [language1])
      login student.user
      get :matching, {language_ids: student.languages.map(&:id), programming_language_ids: student.programming_languages.map(&:id)}, valid_session
      assigns(:job_offers_list)[:items].to_a.should eq([job3, job1])
    end
  end


  describe "PUT prolong" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :running))
      @staff = FactoryGirl.create(:staff, employer: @job_offer.employer)
      @job_offer.update({ responsible_user_id: @staff.id, end_date: Date.current + 10 })
      login @staff.user
    end

    it "should prolong the job" do
      put :prolong, {id: @job_offer.id, job_offer: { end_date: Date.current + 100 } }
      assigns(:job_offer).end_date.should eq(Date.current + 100)
    end

    it "should handle invalid end_dates" do
      put :prolong, {id: @job_offer.id, job_offer: { end_date: '20-40-2014' } }
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET complete" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :running), assigned_students: [FactoryGirl.create(:student)])
    end

    it "marks jobs as completed if the user is staff of the employer" do
      completed = FactoryGirl.create(:job_status, :completed)
      login FactoryGirl.create(:staff, employer: @job_offer.employer).user

      get :complete, { id: @job_offer.id }
      assigns(:job_offer).status.should eq(completed)
    end
    it "prohibits user to mark jobs as completed if he is no staff of the employer" do
      get :complete, { id: @job_offer.id}, valid_session
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET accept" do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, employer: employer)
      FactoryGirl.create(:employers_newsletter_information, employer: employer)
      FactoryGirl.create(:programming_languages_newsletter_information)
    end

    it "prohibits user to accept job offers if he is not the deputy" do
      login @job_offer.responsible_user.user
      get :accept, { id: @job_offer.id }
      response.should redirect_to(job_offers_path)
    end

    it "accepts job offers" do
      login employer.deputy.user
      get :accept, {id: @job_offer.id}
      assigns(:job_offer).status.should eq(JobStatus.open)
      ActionMailer::Base.deliveries.count.should >= 1
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET decline" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, employer: employer)
    end

    it "prohibits user to decline job offers if he is not the deputy" do
      get :decline, {id: @job_offer.id}
      response.should redirect_to(@job_offer)
    end

    it "declines job offers" do
      login employer.deputy.user
      expect {
        get :decline, {id: @job_offer.id}
      }.to change(JobOffer, :count).by(-1)
      response.should redirect_to(job_offers_path)
    end
  end

  describe "GET reopen" do
    describe "with valid params" do

      before(:each) do
        login responsible_user.user
        @job_offer = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :running), responsible_user: responsible_user)
      end

      it "assigns a new job_offer as @job_offer" do
        get :reopen, {id: @job_offer}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
        response.should render_template("new")
      end

      it "has same values as the original job offer" do
        get :reopen, {id: @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        expected_attr = [:description, :title, :time_effort, :compensation, :room_number, :employer_id, :responsible_user_id]

        reopend_job_offer.attributes.with_indifferent_access.slice(expected_attr).should eql(@job_offer.attributes.with_indifferent_access.slice(expected_attr))
        reopend_job_offer.start_date.should be_nil
        reopend_job_offer.end_date.should be_nil
        reopend_job_offer.assigned_students.should be_empty
      end

      it "is pending and old job offer changes to completed" do
        get :reopen, {id: @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        @job_offer.reload.status.should eql(completed)
      end
    end
  end

  describe "POST create" do

    before(:each) do
      login responsible_user.user
    end

    describe "with valid params" do
      it "allows staff members to create a new job offer" do
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        response.should redirect_to job_offer_path(JobOffer.last)
      end

      it "allows the admin to create a new job offer" do
        login FactoryGirl.create(:user, :admin)
        expect {
          post :create, { job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
        response.should redirect_to job_offer_path(JobOffer.last)
      end

      it "doesn't allow students to create a job offer" do
        login FactoryGirl.create(:student).user
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        response.should redirect_to job_offers_path
      end

      it "creates a new job_offer" do
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {job_offer: valid_attributes}, valid_session
        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {job_offer: valid_attributes}, valid_session
        response.should redirect_to(JobOffer.last)
      end

      it "automatically assigns the users employer as the new job offers employer" do
        post :create, {job_offer: valid_attributes}, valid_session
        offer = JobOffer.last
        expect(offer.employer).to eq(responsible_user.employer)
      end

      it "automatically converts 'Haustarif'" do
        attributes = valid_attributes
        attributes["compensation"] = I18n.t('job_offers.default_compensation')

        post :create, {job_offer: attributes}, valid_session
        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
        offer = JobOffer.last
        assert_equal(offer.compensation, 10.0)
      end

      it "automatically converts 'ab sofort' as a start date" do
        attributes = valid_attributes
        attributes["start_date"] = I18n.t('job_offers.default_startdate')

        expect{
          post :create, {job_offer: attributes}, valid_session
        }.to change(JobOffer, :count).by(1)

        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
        offer = JobOffer.last
        assert_equal(offer.start_date, Date.current + 1)
        assert_equal(offer.flexible_start_date, true)
      end

      it "does not create a joboffer if employer is deactivated" do
        staff = FactoryGirl.create :staff
        staff.employer.update_column :activated, false
        login staff.user
                expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {job_offer: { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        expect {
          post :create, {job_offer: valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        response.should render_template("new")
      end

      it "should not send mail to deputy" do
        job_offer = FactoryGirl.create(:job_offer)
        #expect
        JobOffersMailer.should_not_receive(:new_job_offer_email).with( job_offer, valid_session )
        # when
        FactoryGirl.create(:job_offer)
      end

      it "handles an invalid start date" do
        attributes = valid_attributes
        attributes["start_date"] = '20-40-2014'

        expect {
          post :create, {job_offer: attributes}, valid_session
        }.to change(JobOffer, :count).by(0)
        response.should render_template("new")
      end

    end
  end

  describe "PUT update" do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      login @job_offer.responsible_user.user
    end

    describe "with valid params" do
      it "updates the requested job_offer" do
        JobOffer.any_instance.should_receive(:update).with({ "description" => "MyString" })
        put :update, {id: @job_offer.to_param, job_offer: { "description" => "MyString" }}, valid_session
      end

      it "redirects to the job_offer page if the job is already running" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end

      it "assigns the requested job_offer as @job_offer" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "redirects to the job_offer" do
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end

      it "only allows the responsible user to update" do
        login FactoryGirl.create(:staff, employer: @job_offer.employer).user
        put :update, {id: @job_offer.to_param, job_offer: valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end
    end

    describe "with invalid params" do
      it "assigns the job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {id: @job_offer.to_param, job_offer: { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {id: @job_offer.to_param, job_offer: { "description" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      login @job_offer.responsible_user.user
    end

    it "destroys the requested job_offer" do
      expect {
        delete :destroy, {id: @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(-1)
    end

    it "redirects to the job_offers list" do
      delete :destroy, {id: @job_offer.to_param}, valid_session
      response.should redirect_to(job_offers_url)
    end

    it "redirects to the job offer page and keeps the offer if the job is running" do
      @job_offer.update!(status: FactoryGirl.create(:job_status, :running))
      login @job_offer.responsible_user.user

      expect {
        delete :destroy, {id: @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(0)
      response.should redirect_to(@job_offer)
    end
  end


  describe "POST fire" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)
      @job_offer.update!({assigned_students: [FactoryGirl.create(:student)]})
      login @job_offer.responsible_user.user
    end

    it "fires the student" do

      old_offer = @job_offer

      post :fire, {id: @job_offer.to_param, job_offer: { student_id: @job_offer.assigned_students[0].id} }, valid_session

      assert_equal(old_offer.vacant_posts+1, @job_offer.reload.vacant_posts)
      assert_equal(0, @job_offer.reload.assigned_students.count)
      assert_equal(@job_offer.reload.status, JobStatus.open)
    end

    describe "without the required permissions" do
      before(:each) do
        @job_offer = FactoryGirl.create(:job_offer)
        @job_offer.update!({assigned_students: [FactoryGirl.create(:student)]})
      end

      it "doesn't allow students to fire other students" do
        login FactoryGirl.create(:student).user
        expect{
          post :fire, {id: @job_offer.to_param, job_offer: { student_id: @job_offer.assigned_students[0].id} }, valid_session
        }.to change(@job_offer.reload.assigned_students, :count).by(0)
      end

      it "doesn't allow normal staff to fire students" do
        login FactoryGirl.create(:staff).user
        expect{
          post :fire, {id: @job_offer.to_param, job_offer: { student_id: @job_offer.assigned_students[0].id} }, valid_session
        }.to change(@job_offer.reload.assigned_students, :count).by(0)
      end
    end
  end
end