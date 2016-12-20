require 'spec_helper'

describe "employers/show" do
  before(:each) do
    @employer = assign(:employer, FactoryGirl.create(:employer))
    view.stub(:can?) { false }
    view.stub(:signed_in?) { true }
    view.stub(:current_user) { FactoryGirl.create(:user, :admin) }
  end
end
