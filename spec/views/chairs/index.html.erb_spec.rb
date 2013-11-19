require 'spec_helper'

describe "chairs/index" do
  before(:each) do
    assign(:chairs, [
      stub_model(Chair,
        :name => "HCI", :describtion => "Human Computer Interaction", :head_of_chair => stub_model(User, :email => "max.mustermann@student.hpi.uni-potsdam.de", 
                  :identity_url => "https://openid.hpi.uni-potsdam.de/user/max.mustermann", 
                  :firstname => "Max", 
                  :lastname => "mustermann")
      ),
      stub_model(Chair,
        :name => "HCI", :describtion => "Human Computer Interaction", :head_of_chair => stub_model(User, :email => "max.mustermann@student.hpi.uni-potsdam.de", 
                  :identity_url => "https://openid.hpi.uni-potsdam.de/user/max.mustermann", 
                  :firstname => "Max", 
                  :lastname => "mustermann")
      )
    ])
  end

  it "renders a list of chairs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "HCI".to_s, :count => 2
  end
end
