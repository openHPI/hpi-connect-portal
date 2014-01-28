require 'spec_helper'

describe "employers/index" do
  before(:each) do
    assign(:employers, [
      stub_model(Employer,
        :name => "HCI", :description => "Human Computer Interaction", :head => "Prof. Patrick Baudisch"
      ),
      stub_model(Employer,
        :name => "HCI", :description => "Human Computer Interaction", :head => "Prof. Patrick Baudisch"
      )
    ])
    view.stub(:can?) { false }
    view.stub(:signed_in?) { false }
  end

  it "renders a list of employers" do
    view.stub(:will_paginate)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "a", :text => "HCI".to_s, :count => 2
    assert_select "li>div", :text => t("activerecord.attributes.employer.head") + ": " + "Prof. Patrick Baudisch".to_s, :count => 2
  end

  it "only renders the new employer button for the admin" do
    view.stub(:will_paginate)
    view.stub(:can?) { true }
    render

    assert_select "a", :text => I18n.t('employers.new_employer')
  end
end
