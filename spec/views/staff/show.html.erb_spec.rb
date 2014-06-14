require 'spec_helper'

describe "staff/show" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      user: stub_model(User,
        firstname: "First Name",
        lastname: "Last Name",
        email: "staff@test.de"
      ),
      employer: stub_model(Employer,
        name: "Employer"
      )
    ))

    view.stub(:signed_in?) { false }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
  end
end
