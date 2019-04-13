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

require 'rails_helper'

describe FaqsController do

  before(:each) do
    login FactoryBot.create(:student).user
  end

  let(:valid_attributes) { { "question" => "Is this a question?", "answer" => "Yes", "locale" => "en"} }

  describe "GET index" do
    it "assigns all faqs as @faqs" do
      faq = FactoryBot.create(:faq)
      get :index
      expect(assigns(:faqs)).to eq([faq])
    end
  end

  describe "GET new" do
    it "assigns a new faq as @faq" do
      get :new
      expect(assigns(:faq)).to be_a_new(Faq)
    end
  end

  describe "GET edit" do
    it "assigns the requested faq as @faq" do
      faq = FactoryBot.create(:faq)
      get :edit, params: { id: faq.to_param }
      expect(assigns(:faq)).to eq(faq)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Faq" do
        expect {
          post :create, params: { faq: valid_attributes }
        }.to change(Faq, :count).by(1)
      end

      it "assigns a newly created faq as @faq" do
        post :create, params: { faq: valid_attributes }
        expect(assigns(:faq)).to be_a(Faq)
        expect(assigns(:faq)).to be_persisted
      end

      it "redirects to faqs index" do
        post :create, params: { faq: valid_attributes }
        expect(response).to redirect_to(faqs_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved faq as @faq" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Faq).to receive(:save).and_return(false)
        post :create, params: { faq: { "question" => "invalid value" } }
        expect(assigns(:faq)).to be_a_new(Faq)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Faq).to receive(:save).and_return(false)
        post :create, params: { faq: { "question" => "invalid value" } }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested faq" do
        faq = FactoryBot.create(:faq)
        # Assuming there are no other faqs in the database, this
        # specifies that the Faq created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Faq).to receive(:update).with({ "question" => "Is this a test?", "answer" => "Yes"})
        put :update, params: { id: faq.to_param, faq: { "question" => "Is this a test?", "answer" => "Yes"} }
      end

      it "assigns the requested faq as @faq" do
        faq = FactoryBot.create(:faq)
        put :update, params: { id: faq.to_param, faq: valid_attributes }
        expect(assigns(:faq)).to eq(faq)
      end

      it "redirects to the faqs index" do
        faq = FactoryBot.create(:faq)
        put :update, params: { id: faq.to_param, faq: valid_attributes }
        expect(response).to redirect_to(faqs_path)
      end

      describe "with invalid params" do
        it "assigns the faq as @faq" do
          faq = FactoryBot.create(:faq)
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Faq).to receive(:save).and_return(false)
          put :update, params: { id: faq.to_param, faq: { "question" => "invalid value" } }
          expect(assigns(:faq)).to eq(faq)
        end

        it "re-renders the 'edit' template" do
          faq = FactoryBot.create(:faq)
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Faq).to receive(:save).and_return(false)
          put :update, params: { id: faq.to_param, faq: { "question" => "invalid value" } }
          expect(response).to render_template("edit")
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested faq" do
      faq = FactoryBot.create(:faq)
      expect {
        delete :destroy, params: { id: faq.to_param }
      }.to change(Faq, :count).by(-1)
    end

    it "redirects to the faqs list" do
      faq = FactoryBot.create(:faq)
      delete :destroy, params: { id: faq.to_param }
      expect(response).to redirect_to(faqs_url)
    end
  end
end
