require 'spec_helper'

describe "employers/index" do
  before(:each) do
    assign(:employers, [
      stub_model(Employer,
        :name => "HCI", :description => "Human Computer Interaction"
      ),
      stub_model(Employer,
        :name => "HCI", :description => "Human Computer Interaction"
      )
    ])
        
    assign(:premium_employers,[
      stub_model(Employer,
        :name => "Premium Employer", :description => "some description", :premium? => true
      ),
      stub_model(Employer,
      :name => "Premium Employer", :description => "some description", :premium? => true
      )  
    ])
            
    view.stub(:can?) { false }
    view.stub(:signed_in?) { false }
  end

  it "renders a list of employers" do
    view.stub(:will_paginate)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", :text => "HCI".to_s, :count => 2
  end

  it "only renders the new employer button for the admin" do
    view.stub(:will_paginate)
    view.stub(:can?) { true }
    render

    assert_select "a", :text => I18n.t('employers.new_employer')
  end
end
