require 'spec_helper'

describe "chairs/new" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair,
      :name => "HCI", :describtion => "Human Computer Interaction", :head_of_chair => stub_model(User, :email => "max.mustermann@student.hpi.uni-potsdam.de", 
                  :identity_url => "https://openid.hpi.uni-potsdam.de/user/max.mustermann", 
                  :firstname => "Max", 
                  :lastname => "mustermann")
    ).as_new_record)
    @users = User.all
  end

  it "renders new chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", chairs_path, "post" do
      assert_select "input#chair_name[name=?]", "chair[name]"
    end
  end
end
