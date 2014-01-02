require 'spec_helper'

describe "user_statuses/index" do
  before(:each) do
    assign(:user_statuses, [
      stub_model(UserStatus,
        :name => "Description"
      ),
      stub_model(UserStatus,
        :name => "Description"
      )
    ])
  end

  it "renders a list of user_statuses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
