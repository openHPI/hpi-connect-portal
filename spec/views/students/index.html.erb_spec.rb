require 'spec_helper'

describe "students/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :semester => 1,
        :academic_program_id => 0,
        :birthday => '2013-11-10',
        :graduation_id => 1,
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
      ),
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :semester => 1,
        :academic_program_id => 2,
        :birthday => '2013-11-10',
        :graduation_id => 3,
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
      )
    ])
  end
end
