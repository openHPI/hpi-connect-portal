require 'spec_helper'

describe JobOffersController do

  login_user FactoryGirl.create(:role, name: 'Student')

  let(:assigned_student) { FactoryGirl.create(:user) }
  let(:employer) { FactoryGirl.create(:employer) }
  let(:responsible_user) { FactoryGirl.create(:user, employer: employer, role: FactoryGirl.create(:role, :staff)) }
  let(:completed) {FactoryGirl.create(:job_status, :completed)}
  let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :open), "responsible_user_id" => responsible_user.id } }
  let(:valid_attributes_status_running) {{"title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :running), "assigned_student_id" => assigned_student.id, "responsible_user_id" => responsible_user.id }}
  let(:valid_attributes_status_completed) {{"title"=>"Open HPI Job", "description" => "MyString", "employer_id" => employer.id, "start_date" => Date.current + 1,
    "time_effort" => 3.5, "compensation" => 10.30, "status" => completed, "assigned_student_id" => assigned_student.email, "responsible_user_id" => responsible_user.id }}

  let(:valid_session) { {} }

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
    
    @employer_one = FactoryGirl.create(:employer)
    @employer_two = FactoryGirl.create(:employer)
    @employer_three = FactoryGirl.create(:employer)
    @open = FactoryGirl.create(:job_status, name:"open")
  end

  describe "Check if views are rendered" do
    render_views

    it "renders the find results" do
      job_offer = FactoryGirl.create(:job_offer)
      get :index, ({:employer => employer.id}), valid_session
      response.should render_template("index")
    end

    it "renders the archive" do
      job_offer = FactoryGirl.create(:job_offer)
      get :archive, {}, valid_session
      response.should render_template("archive")
    end

    it "renders the jobs found archive" do
      job_offer = FactoryGirl.create(:job_offer)
      get :archive, ({:search => "Ruby"}), valid_session
      response.should render_template("archive")
    end
  end

  describe "GET index" do
    it "assigns all job_offers as @job_offer-list[:items]" do
      job_offer = FactoryGirl.create(:job_offer, status: @open)
      get :index, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([job_offer])
    end
  end

  describe "GET archive" do
    it "assigns all archive job_offers as @job_offerlist[:items]" do
      job_offer = FactoryGirl.create(:job_offer, status: completed)
      get :archive, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([job_offer])
    end

    it "does not assign non-completed jobs" do
      job_offer = FactoryGirl.create(:job_offer)
      get :archive, {}, valid_session
      assert assigns(:job_offers_list)[:items].empty?
    end
  end

  describe "GET show" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = FactoryGirl.create(:job_offer)
      get :show, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end

    it "assigns a possible applications as @application" do
      user = FactoryGirl.create(:user)
      sign_in user

      job_offer = FactoryGirl.create(:job_offer)
      application = FactoryGirl.create(:application, user: user, job_offer: job_offer)
      get :show, {:id => job_offer.to_param}, valid_session
      assigns(:application).should eq(application)
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      sign_in responsible_user
      get :new, {}, valid_session
      assigns(:job_offer).should be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = FactoryGirl.create(:job_offer)
      get :edit, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end

    it "only allows the responsible user to edit" do
      job_offer = FactoryGirl.create(:job_offer)
      job_offer.responsible_user = FactoryGirl.create(:user)
      job_offer.save
      get :edit, {:id => job_offer.to_param}, valid_session
      response.should redirect_to(job_offer)
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

  describe "PUT prolong" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :running))
      @user = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :staff), employer: @job_offer.employer)
      @job_offer.update({ responsible_user_id: @user.id, end_date: Date.current + 10 })
      sign_in @user
    end

    it "should prolong the job" do
      put :prolong, {id: @job_offer.id, job_offer: { end_date: Date.current + 100 } }
      assigns(:job_offer).end_date.should eq(Date.current + 100)
    end
  end

  describe "GET complete" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, :running), assigned_student: FactoryGirl.create(:user))
    end

    it "marks jobs as completed if the user is staff of the employer" do 
      completed = FactoryGirl.create(:job_status, :completed)
      sign_in FactoryGirl.create(:user, :staff, employer: @job_offer.employer)
      
      get :complete, { id: @job_offer.id }
      assigns(:job_offer).status.should eq(completed)
    end
    it "prohibits user to mark jobs as completed if he is no staff of the employer" do 
      get :complete, { id: @job_offer.id}, valid_session
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET accept" do 
    let(:deputy) { FactoryGirl.create(:user, employer: employer) }
    before(:each) do
      employer.update(deputy: deputy)
      @job_offer = FactoryGirl.create(:job_offer)
      @job_offer.update(employer: employer, status: FactoryGirl.create(:job_status))
    end

    it "prohibits user to accept job offers if he is not the deputy" do

      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      get :accept, { id: @job_offer.id }
      response.should redirect_to(job_offers_path)
    end     
    it "accepts job offers" do
      sign_in deputy
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      get :accept, {:id => @job_offer.id}
      assigns(:job_offer).status.should eq(JobStatus.open) 
      response.should redirect_to(@job_offer)
    end    
  end

  describe "GET decline" do
    let(:deputy) { FactoryGirl.create(:user, employer: employer) }
    before(:each) do
      employer.update(deputy: deputy)
      @job_offer = FactoryGirl.create(:job_offer)
      @job_offer.update(employer: employer, status: FactoryGirl.create(:job_status))
    end

    it "prohibits user to decline job offers if he is not the deputy" do
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      get :decline, {id: @job_offer.id}
      response.should redirect_to(job_offers_path)
    end     
    it "declines job offers" do
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      sign_in deputy
      expect {
        get :decline, {id: @job_offer.id}
      }.to change(JobOffer, :count).by(-1)
      response.should redirect_to(job_offers_path)
    end 
  end

  describe "GET reopen" do
    describe "with valid params" do

      before(:each) do
        sign_in responsible_user
        @job_offer = FactoryGirl.create(:job_offer)
        @job_offer.update(employer: employer, status: FactoryGirl.create(:job_status, :running), responsible_user: responsible_user)
      end

      it "assigns a new job_offer as @job_offer" do
        get :reopen, {:id => @job_offer}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
        response.should render_template("new")
      end

      it "has same values as the original job offer" do
        get :reopen, {:id => @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        expected_attr = [:description, :title, :time_effort, :compensation, :room_number, :employer_id, :responsible_user_id]        

        reopend_job_offer.attributes.with_indifferent_access.slice(expected_attr).should eql(@job_offer.attributes.with_indifferent_access.slice(expected_attr))
        reopend_job_offer.start_date.should be_nil
        reopend_job_offer.end_date.should be_nil
        reopend_job_offer.assigned_student_id.should be_nil
      end

      it "is pending and old job offer changes to completed" do
        get :reopen, {:id => @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        JobOffer.find(@job_offer).status.should eql(completed)
      end
    end
  end

  describe "POST create" do

    before(:each) do
      sign_in responsible_user
    end
    
    describe "with valid params" do
      it "creates a new job_offer" do
        expect {
          post :create, {:job_offer => valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        response.should redirect_to(JobOffer.last)
      end

      it "automatically assigns the users employer as the new job offers employer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        offer = JobOffer.last
        expect(offer.employer).to eq(responsible_user.employer)
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
      it "should not send mail to deputy" do
        job_offer = FactoryGirl.create(:job_offer)
        #expect
        JobOffersMailer.should_not_receive(:new_job_offer_email).with( job_offer, valid_session )
        # when
        FactoryGirl.create(:job_offer)
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      sign_in @job_offer.responsible_user
    end

    describe "with valid params" do
      it "updates the requested job_offer" do
        JobOffer.any_instance.should_receive(:update).with({ "description" => "MyString" })
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "MyString" }}, valid_session
      end

      it "redirects to the job_offer page if the job is already running" do
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end

      it "assigns the requested job_offer as @job_offer" do
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "redirects to the job_offer" do
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end

      it "only allows the responsible user to update" do
        @job_offer.responsible_user = FactoryGirl.create(:user)
        @job_offer.save
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end
    end

    describe "with invalid params" do
      it "assigns the job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)

      sign_in @job_offer.responsible_user
    end

    it "destroys the requested job_offer" do
      expect {
        delete :destroy, {:id => @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(-1)
    end

    it "redirects to the job_offers list" do
      delete :destroy, {:id => @job_offer.to_param}, valid_session
      response.should redirect_to(job_offers_url)
    end
  end

end
