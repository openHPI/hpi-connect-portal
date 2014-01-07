require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }

  let(:valid_attributes) { { "firstname" => "Mister", "lastname" => "Awesome", "email" => "test@example.com", "role" => student_role } }
  let(:false_attributes) { { "firstname" => 123 } }
  let(:valid_session) { {} }

  before(:each) do
  	sign_in FactoryGirl.create(:user)
  end

  # describe "GET index" do
  #   it "assigns all job_offers as @job_offer-list[:items]" do
  #     job_offer = JobOffer.create! valid_attributes
  #     get :index, {}, valid_session
  #     assigns(:job_offers_list)[:items].should eq([job_offer])
  #   end
  # end

  # describe "GET archive" do
  #   it "assigns all archive job_offers as @job_offerlist[:items]" do
  #     job_offer = JobOffer.create! valid_attributes_status_completed
  #     get :archive, {}, valid_session
  #     assigns(:job_offers_list)[:items].should eq([job_offer])
  #   end

  #   it "does not assign non-completed jobs" do
  #     job_offer = JobOffer.create! valid_attributes
  #     get :archive, {}, valid_session
  #     assert assigns(:job_offers_list)[:items].empty?
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested job_offer as @job_offer" do
  #     job_offer = JobOffer.create! valid_attributes
  #     get :show, {:id => job_offer.to_param}, valid_session
  #     assigns(:job_offer).should eq(job_offer)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new job_offer as @job_offer" do
  #     get :new, {}, valid_session
  #     assigns(:job_offer).should be_a_new(JobOffer)
  #   end
  # end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      sign_in user
      get :edit, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end

    it "only allows the user or admin to edit" do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}, valid_session
      response.should redirect_to(user)
	end
  end

  describe "PUT update" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      sign_in user
      put :update, { :id => user.id, :user => valid_attributes }, valid_session
      assigns(:user).should eq(user)
    end

    it "only allows the user or admin to update" do
      user = User.create! valid_attributes
      put :update, { :id => user.id, :user => valid_attributes }, valid_session
      response.should redirect_to(user)
	  end

    it "handles a failing update call" do
      troubling_user = FactoryGirl.create(:user)

      user = User.create! valid_attributes
      sign_in user
      patch :update, { :id => user.id, :user => { 'email' => troubling_user.email} }, valid_session
      flash[:error].should eql("Error while updating profile.")
    end

  end

  # describe "GET find" do
  #   it "assigns @job_offers_list[:items] to all job offers with the chair EPIC" do

  #     FactoryGirl.create(:job_offer, chair: @itas, status: @open)
  #     FactoryGirl.create(:job_offer, chair: @epic, status: @open)
  #     FactoryGirl.create(:job_offer, chair: @os, status: @open)
  #     FactoryGirl.create(:job_offer, chair: @epic, status: @open)

  #     job_offers = JobOffer.find_jobs ({:filter => {:chair => @epic.id}})
  #     get :find, ({:chair => @epic.id}), valid_session
  #     assigns(:job_offers_list)[:items].to_a.should =~ (job_offers).to_a
  #   end
  # end

  # describe "GET complete" do
  #   before(:each) do
  #     @job_offer = JobOffer.create! valid_attributes_status_running
  #   end

  #   it "marks jobs as completed if the user is research assistant of the chair" do 
  #     completed = FactoryGirl.create(:job_status, name: "completed")
  #     sign_in FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Research Assistant', level: 2), chair: @job_offer.chair)
      
  #     get :complete, {:id => @job_offer.id}
  #     assigns(:job_offer).status.should eq(completed)      
  #   end
  #   it "prohibits user to mark jobs as completed if he is no research assistant of the chair" do 
  #     get :complete, {:id => @job_offer.id}, valid_session
  #     response.should redirect_to(@job_offer)
  #   end
  # end

  # describe "GET accept" do 
  #   let(:deputy) { FactoryGirl.create(:user, chair: chair) }
  #   before(:each) do
  #     chair.update(deputy: deputy)
  #     @job_offer = JobOffer.create! valid_attributes
  #     @job_offer.update(chair: chair, status: FactoryGirl.create(:job_status, name: "pending"))
  #   end

  #   it "prohibits user to accept job offers if he is not the deputy" do

  #     @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
  #     get :accept, {id: @job_offer.id}
  #     response.should redirect_to(job_offers_path)
  #   end     
  #   it "accepts job offers" do
  #     sign_in deputy
  #     @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
  #     @job_offer.save
  #     get :accept, {:id => @job_offer.id}
  #     assigns(:job_offer).status.should eq(JobStatus.open) 
  #     response.should redirect_to(@job_offer)
  #   end    
  # end

  # describe "GET decline" do
  #   let(:deputy) { FactoryGirl.create(:user, chair: chair) }
  #   before(:each) do
  #     chair.update(deputy: deputy)
  #     @job_offer = JobOffer.create! valid_attributes
  #     @job_offer.update(chair: chair, status: FactoryGirl.create(:job_status, name: "pending"))
  #   end

  #   it "prohibits user to decline job offers if he is not the deputy" do
  #     @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
  #     @job_offer.save
  #     get :decline, {id: @job_offer.id}
  #     response.should redirect_to(job_offers_path)
  #   end     
  #   it "declines job offers" do
  #     @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
  #     @job_offer.save
  #     sign_in deputy
  #     expect {
  #       get :decline, {id: @job_offer.id}
  #     }.to change(JobOffer, :count).by(-1)
  #     response.should redirect_to(job_offers_path)
  #   end 
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new job_offer" do
  #       expect {
  #         post :create, {:job_offer => valid_attributes}, valid_session
  #       }.to change(JobOffer, :count).by(1)
  #     end

  #     it "assigns a newly created job_offer as @job_offer" do
  #       post :create, {:job_offer => valid_attributes}, valid_session
  #       assigns(:job_offer).should be_a(JobOffer)
  #       assigns(:job_offer).should be_persisted
  #     end

  #     it "redirects to the created job_offer" do
  #       post :create, {:job_offer => valid_attributes}, valid_session
  #       response.should redirect_to(JobOffer.last)
  #     end

  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved job_offer as @job_offer" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       JobOffer.any_instance.stub(:save).and_return(false)
  #       post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
  #       assigns(:job_offer).should be_a_new(JobOffer)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       JobOffer.any_instance.stub(:save).and_return(false)
  #       post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
  #       response.should render_template("new")
  #     end
  #     it "should not send mail to deputy" do
  #       job_offer = JobOffer.create! valid_attributes
  #       #expect
  #       JobOffersMailer.should_not_receive(:new_job_offer_email).with( job_offer, valid_session )
  #       # when
  #       JobOffer.create! valid_attributes
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested job_offer" do
  #       job_offer = JobOffer.create! valid_attributes
  #       # Assuming there are no other job_offers in the database, this
  #       # specifies that the job_offer created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       JobOffer.any_instance.should_receive(:update).with({ "description" => "MyString" })
  #       put :update, {:id => job_offer.to_param, :job_offer => { "description" => "MyString" }}, valid_session
  #     end

  #     it "assigns the requested job_offer as @job_offer" do
  #       job_offer = JobOffer.create! valid_attributes
  #       put :update, {:id => job_offer.to_param, :job_offer => valid_attributes}, valid_session
  #       assigns(:job_offer).should eq(job_offer)
  #     end

  #     it "redirects to the job_offer" do
  #       job_offer = JobOffer.create! valid_attributes
  #       put :update, {:id => job_offer.to_param, :job_offer => valid_attributes}, valid_session
  #       response.should redirect_to(job_offer)
  #     end

  #     it "only allows the responsible user to update" do
  #       job_offer = JobOffer.create! valid_attributes
  #       job_offer.responsible_user = FactoryGirl.create(:user)
  #       job_offer.save
  #       put :update, {:id => job_offer.to_param, :job_offer => valid_attributes}, valid_session
  #       response.should redirect_to(job_offer)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the job_offer as @job_offer" do
  #       job_offer = JobOffer.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       JobOffer.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
  #       assigns(:job_offer).should eq(job_offer)
  #     end

  #     it "re-renders the 'edit' template" do
  #       job_offer = JobOffer.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       JobOffer.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested job_offer" do
  #     job_offer = JobOffer.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => job_offer.to_param}, valid_session
  #     }.to change(JobOffer, :count).by(-1)
  #   end

  #   it "redirects to the job_offers list" do
  #     job_offer = JobOffer.create! valid_attributes
  #     delete :destroy, {:id => job_offer.to_param}, valid_session
  #     response.should redirect_to(job_offers_url)
  #   end
  # end

end
