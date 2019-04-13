# == Schema Information
#
# Table name: newsletter_orders
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  search_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe NewsletterOrdersController do
  describe "DELETE destroy" do

    before(:each) do
      @newsletter_order = FactoryBot.create(:newsletter_order)
    end

    it "deletes newsletter if student belongs to newsletter" do
      login @newsletter_order.student.user
      delete :destroy, params: { id: @newsletter_order.id }
      expect(NewsletterOrder.count).to eq(0)
    end

    it "does not delete newsletter if student is not allowed" do
      login FactoryBot.create(:user)
      delete :destroy, params: { id: @newsletter_order.id }
      expect(NewsletterOrder.count).to eq(1)
    end

    it "redirect to root if not logged in" do
      delete :destroy, params: { id: @newsletter_order.id }
      expect(NewsletterOrder.count).to eq(1)
      expect(response).to redirect_to(root_path)
    end

    it "redirects to job_offers_index" do
      login @newsletter_order.student.user
      delete :destroy, params: { id: @newsletter_order.id }
      expect(response).to redirect_to(job_offers_path)
    end
  end

  describe "POST create" do
    let(:valid_attributes) { { newsletter_params:  { state: 2 } } }
    let(:student) { FactoryBot.create(:student) }

    context "when logged in as student" do
      before(:each) do
        login student.user
      end

      it "creates a newsletter order when given attributes" do
        expect {
          post :create, params: valid_attributes
        }.to change(NewsletterOrder, :count).by(1)
      end

      it "creates a newsletter order when not given attributes" do
        expect {
          post :create, params: {}
        }.to change(NewsletterOrder, :count).by(1)
      end

      it "redirects to job offers index" do
        post :create, params: valid_attributes
        expect(response).to redirect_to job_offers_path
      end
    end
  end

  describe "GET show" do

    before(:each) do
      search_hash = {state: 3}
      @newsletter_order = FactoryBot.create(:newsletter_order, search_params: search_hash)
    end

    it "should show newsletter_order" do
      login @newsletter_order.student.user
      get :show, params: { id: @newsletter_order.to_param }
      expect(response).to render_template("show")
    end

    it "should not show newsletter_order if not allowed" do
      login FactoryBot.create(:student).user
      get :show, params: { id: @newsletter_order.to_param }
      expect(response).to redirect_to(root_path)
    end
  end
end
