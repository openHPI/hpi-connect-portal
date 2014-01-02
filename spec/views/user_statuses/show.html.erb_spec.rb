require 'spec_helper'

describe "user_statuses/show" do
  before(:each) do
    @student_status = assign(:user_status, stub_model(UserStatus,
      :name => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
