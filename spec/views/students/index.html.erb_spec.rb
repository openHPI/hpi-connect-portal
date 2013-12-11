require 'spec_helper'

describe "students/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :semester => 1,
        :academic_program => "Academic Program",
        :birthday => '2013-11-10',
        :education => "MyEducation",
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
        :is_student=> true
      ),
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :semester => 1,
        :academic_program => "Academic Program",
        :birthday => '2013-11-10',
        :education => "MyEducation",
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
        :is_student => true
      )
    ])
  end

  it "renders a list of students" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Academic Program".to_s, :count => 2
  end
end
