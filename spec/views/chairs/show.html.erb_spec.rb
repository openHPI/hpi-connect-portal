require 'spec_helper'

describe "chairs/show" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair,
      :name => "HCI", :describtion => "Human Computer Interaction", :head_of_chair => stub_model(User, :email => "max.mustermann@student.hpi.uni-potsdam.de", 
                  :identity_url => "https://openid.hpi.uni-potsdam.de/user/max.mustermann", 
                  :firstname => "Max", 
                  :lastname => "mustermann")
    ))
    @head_of_chair = User.new(email: 'email@hpi.uni-potsdam.de')
  end

  xit "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/HCI/)
  end
end
