require 'spec_helper'

describe "employers/show" do
  before(:each) do
    @employer = assign(:employer, stub_model(Employer,
      :name => "HCI", :description => "Human Computer Interaction", :head => "Prof. Patrick Baudisch", :deputy => FactoryGirl.create(:user)
    ))
    view.stub(:can?) { false }
  end

  xit "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/HCI/)
    rendered.should match(/Human Computer Interaction/)
    rendered.should match(/Prof. Patrick Baudisch/)
    rendered.should match(@employer.deputy.email)
  end
end
