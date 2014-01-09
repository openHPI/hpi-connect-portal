require 'spec_helper'

describe "research_assistants/show" do
  before(:each) do
    @user = assign(:users, stub_model(User,
      :firstname => "First Name",
      :lastname => "Last Name",
      :birthday => '2013-11-10',
      :additional_information => "MyText",
      :homepage => "Homepage",
      :github => "Github",
      :facebook => "Facebook",
      :xing => "Xing",
      :linkedin => "Linkedin"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Homepage/)
    rendered.should match(/Github/)
    rendered.should match(/Facebook/)
    rendered.should match(/Xing/)
    rendered.should match(/Linkedin/)
  end
end
