require 'spec_helper'

describe "staff/show" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      user: {
        :firstname => "First Name",
        :lastname => "Last Name",
      }
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
