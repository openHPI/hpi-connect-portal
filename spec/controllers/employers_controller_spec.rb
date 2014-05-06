require 'spec_helper'

describe EmployersController do

  let(:deputy) { FactoryGirl.create(:staff) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  let(:valid_attributes) { { name: "HCI", description: "Human Computer Interaction",
      deputy_id: deputy.id, 
      number_of_employees: "50", place_of_business: "Potsdam", year_of_foundation: 1998 } }

  let(:false_attributes) { { "name" => "HCI"} }

  before(:each) do
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :pending)

    login admin
  end

  describe "GET index" do
    before(:each) do
      @employer = FactoryGirl.create(:employer)
    end

    it "assigns all employers as @employers" do
      get :index, {}
      assigns(:employers).should eq([@employer])
    end
  end

  describe "GET show" do
    it "assigns the requested employer as @employer" do
      employer = FactoryGirl.create(:employer)
      get :show, { id: employer.to_param }
      assigns(:employer).should eq(employer)
    end
  end

  describe "GET new" do
    it "assigns a new employer as @employer" do
      get :new, {}
      assigns(:employer).should be_a_new(Employer)
    end
  end

  describe "GET edit" do
    describe "with sufficient access rights" do
      it "assigns the requested employer as @employer as admin" do
        employer = FactoryGirl.create(:employer)
        get :edit, { id: employer.to_param }
        assigns(:employer).should eq(employer)
      end

      it "assigns the requested employer as @employer as staff of employer" do
        employer = FactoryGirl.create(:employer)
        login FactoryGirl.create(:staff, employer: employer).user
        get :edit, { id: employer.to_param }
        assigns(:employer).should eq(employer)
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
        response.should redirect_to(employers_path)
        flash[:notice].should eql("You are not authorized to access this page.")
      end
    end
  end

  describe "POST create" do

    describe "with valid params" do

      it "creates a new employer" do
        expect {
          post :create, { employer: valid_attributes }
        }.to change(Employer, :count).by(2)
      end

      it "assigns a newly created employer as @employer" do
        post :create, { employer: valid_attributes }
        assigns(:employer).should be_a(Employer)
        assigns(:employer).should be_persisted
      end

      it "redirects to the created employer" do
        post :create, { employer: valid_attributes }
        response.should redirect_to(Employer.last)
      end

      it "sends an email" do
        old_count = ActionMailer::Base.deliveries.count
        post :create, { employer: valid_attributes }
        ActionMailer::Base.deliveries.count.should == old_count + 1
      end
    end

    describe "with invalid params" do

      it "renders new again" do
        post :create, { employer: false_attributes}
        response.should render_template("new")
      end

      it "does not create a new employer without deputy" do
        post :create, { employer: {"name" => "HCI", "description" => "Human Computer Interaction"}}
        response.should render_template("new")
      end
    end

    describe "with insufficient access rights" do
      
      before(:each) do
        login FactoryGirl.create(:student).user
      end

      it "should also create an employer (there are no insufficient access rights)" do
        employer = FactoryGirl.create(:employer)
        post :create, { employer: valid_attributes }
        response.should redirect_to(employer_path(Employer.last))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        @employer = FactoryGirl.create(:employer)
        @employer.deputy.update_column :employer_id, @employer.id
      end
      
      it "updates the requested employer" do  
        Employer.any_instance.should_receive(:update).with({ "name" => "HCI", "description" => "Human Computer Interaction" } )
        put :update, { id: @employer.to_param, employer: { "name" => "HCI", "description" => "Human Computer Interaction" } }
      end

      it "assigns the requested employer as @employer" do
        put :update, { id: @employer.id, employer: valid_attributes }
        assigns(:employer).should eq(@employer)
      end

      it "redirects to the employer" do
        deputy.update(employer: @employer)
        put :update, { id: @employer.id, employer: valid_attributes }
        response.should redirect_to(@employer)
      end

      it "sends an email if a new package was booked" do
        old_count = ActionMailer::Base.deliveries.count
        put :update, { id: @employer.id, employer: { name: "HCI", description: "Human Computer Interaction", requested_package_id: 2 } }
        ActionMailer::Base.deliveries.count.should == old_count + 1
      end
    end

    describe "with missing permission" do
      
      before(:each) do
        login FactoryGirl.create(:student).user
      end

      it "redirects to the employer index page" do
        employer = FactoryGirl.create(:employer)
        patch :update, { id: employer.id, employer: valid_attributes }
        response.should redirect_to(employers_path)
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
        response.should redirect_to(@employer)
      end

      it "should activate the employer" do
        get :activate, ({ id: @employer.id })
        @employer.reload
        assert @employer.activated
      end
    end

    it "should not be accessible for staff members" do
      staff = FactoryGirl.create(:staff)
      login staff.user
      get :activate, ({ id: FactoryGirl.create(:employer).id })
      response.should redirect_to(employers_path)
      flash[:notice].should eql("You are not authorized to access this page.")
    end

    it "should not be accessible for students" do
      student = FactoryGirl.create(:student)
      login student.user
      get :activate, ({ id: FactoryGirl.create(:employer).id })
      response.should redirect_to(employers_path)
      flash[:notice].should eql("You are not authorized to access this page.")
    end
  end
end
