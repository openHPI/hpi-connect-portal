# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  answer     :text
#  created_at :datetime
#  updated_at :datetime
#  locale     :string(255)
#

require 'spec_helper'

describe FaqsController do

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  let(:valid_attributes) { { "question" => "Is this a question?", "answer" => "Yes", "locale" => "en"} }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all faqs as @faqs" do
      faq = FactoryGirl.create(:faq)
      get :index, {}, valid_session
      assigns(:faqs).should eq([faq])
    end
  end

  describe "GET new" do
    it "assigns a new faq as @faq" do
      get :new, {}, valid_session
      assigns(:faq).should be_a_new(Faq)
    end
  end

  describe "GET edit" do
    it "assigns the requested faq as @faq" do
      faq = FactoryGirl.create(:faq)
      get :edit, {id: faq.to_param}, valid_session
      assigns(:faq).should eq(faq)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Faq" do
        expect {
          post :create, {faq: valid_attributes}, valid_session
        }.to change(Faq, :count).by(1)
      end

      it "assigns a newly created faq as @faq" do
        post :create, {faq: valid_attributes}, valid_session
        assigns(:faq).should be_a(Faq)
        assigns(:faq).should be_persisted
      end

      it "redirects to faqs index" do
        post :create, {faq: valid_attributes}, valid_session
        response.should redirect_to(faqs_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved faq as @faq" do
        # Trigger the behavior that occurs when invalid params are submitted
        Faq.any_instance.stub(:save).and_return(false)
        post :create, {faq: { "question" => "invalid value" }}, valid_session
        assigns(:faq).should be_a_new(Faq)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Faq.any_instance.stub(:save).and_return(false)
        post :create, {faq: { "question" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested faq" do
        faq = FactoryGirl.create(:faq)
        # Assuming there are no other faqs in the database, this
        # specifies that the Faq created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Faq.any_instance.should_receive(:update).with({ "question" => "Is this a test?", "answer" => "Yes"})
        put :update, {id: faq.to_param, faq: { "question" => "Is this a test?", "answer" => "Yes"}}, valid_session
      end

      it "assigns the requested faq as @faq" do
        faq = FactoryGirl.create(:faq)
        put :update, {id: faq.to_param, faq: valid_attributes}, valid_session
        assigns(:faq).should eq(faq)
      end

      it "redirects to the faqs index" do
        faq = FactoryGirl.create(:faq)
        put :update, {id: faq.to_param, faq: valid_attributes}, valid_session
        response.should redirect_to(faqs_path)
      end

      describe "with invalid params" do
        it "assigns the faq as @faq" do
          faq = FactoryGirl.create(:faq)
          # Trigger the behavior that occurs when invalid params are submitted
          Faq.any_instance.stub(:save).and_return(false)
          put :update, {id: faq.to_param, faq: { "question" => "invalid value" }}, valid_session
          assigns(:faq).should eq(faq)
        end

        it "re-renders the 'edit' template" do
          faq = FactoryGirl.create(:faq)
          # Trigger the behavior that occurs when invalid params are submitted
          Faq.any_instance.stub(:save).and_return(false)
          put :update, {id: faq.to_param, faq: { "question" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested faq" do
      faq = FactoryGirl.create(:faq)
      expect {
        delete :destroy, {id: faq.to_param}, valid_session
      }.to change(Faq, :count).by(-1)
    end

    it "redirects to the faqs list" do
      faq = FactoryGirl.create(:faq)
      delete :destroy, {id: faq.to_param}, valid_session
      response.should redirect_to(faqs_url)
    end
  end
end
