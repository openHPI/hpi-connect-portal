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

require 'spec_helper'

describe NewsletterOrdersController do
  describe "DELETE destroy" do

    before(:each) do
      @newsletter_order = FactoryGirl.create(:newsletter_order)
    end

    it "deletes newsletter if student belongs to newsletter" do
      login @newsletter_order.student.user
      delete :destroy, { id: @newsletter_order.id }
      NewsletterOrder.count.should == 0
    end

    it "does not delete newsletter if student is not allowed" do
      login FactoryGirl.create(:user)
      delete :destroy, { id: @newsletter_order.id }
      NewsletterOrder.count.should == 1
    end

    it "redirect to root if not logged in" do
      delete :destroy, { id: @newsletter_order.id }
      NewsletterOrder.count.should == 1
      response.should redirect_to(root_path)
    end

    it "redirects to job_offers_index" do
      login @newsletter_order.student.user
      delete :destroy, { id: @newsletter_order.id }
      response.should redirect_to(job_offers_path)
    end
  end

  describe "POST create" do
    let(:valid_attributes) {{ newsletter_params:  {state: 2}}}
    let(:valid_session) { { }}

    it "creates newsletter if logged in student" do
      login FactoryGirl.create(:student).user
      expect {
        post :create, valid_attributes, valid_session
      }.to change(NewsletterOrder, :count).by(1)
      response.should redirect_to job_offers_path
    end
  end

  describe "GET show" do

    before(:each) do
      search_hash = {state: 3}
      @newsletter_order = FactoryGirl.create(:newsletter_order, search_params: search_hash)
    end

    it "should show newsletter_order" do
      login @newsletter_order.student.user
      get :show, {id: @newsletter_order.to_param}, {}
      response.should render_template("show")
    end

    it "should not show newsletter_order if not allowed" do
      login FactoryGirl.create(:student).user
      get :show, {id: @newsletter_order.to_param}, {}
      response.should redirect_to(root_path)
    end
  end
end
