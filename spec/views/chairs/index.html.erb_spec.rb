require 'spec_helper'

describe "chairs/index" do
  before(:each) do
    assign(:chairs, [
      stub_model(Chair,
        :name => "HCI", :description => "Human Computer Interaction", :head_of_chair => "Prof. Patrick Baudisch"
      ),
      stub_model(Chair,
        :name => "HCI", :description => "Human Computer Interaction", :head_of_chair => "Prof. Patrick Baudisch"
      )
    ])
    view.stub(:can?) { false }
  end

  it "renders a list of chairs" do
    view.stub(:will_paginate)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "a", :text => "HCI".to_s, :count => 2
    assert_select "li>div", :text => t("activerecord.attributes.chair.head_of_chair") + ": " + "Prof. Patrick Baudisch".to_s, :count => 2
  end
end
