require 'spec_helper'

describe "employers/show" do
  before(:each) do
    @employer = assign(:employer, stub_model(Employer,
      name: "HCI", description: "Human Computer Interaction", head: "Prof. Patrick Baudisch"
    ))
    view.stub(:can?) { false }
    view.stub(:signed_in?) { true }
    view.stub(:current_user) { FactoryGirl.create(:user, :admin) }
  end
end
