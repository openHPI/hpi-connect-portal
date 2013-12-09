require 'spec_helper'

describe "chairs/show" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair,
      :name => "HCI", :description => "Human Computer Interaction", :head_of_chair => "Prof. Patrick Baudisch", :deputy => FactoryGirl.create(:user)
    ))
    view.stub(:can?) { false }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/HCI/)
    rendered.should match(/Human Computer Interaction/)
    rendered.should match(/Prof. Patrick Baudisch/)
    rendered.should match(@chair.deputy.email)
  end
end
