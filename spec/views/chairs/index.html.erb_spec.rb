require 'spec_helper'

describe "chairs/index" do
  before(:each) do
    assign(:chairs, [
      stub_model(Chair,
        :name => "Name"
      ),
      stub_model(Chair,
        :name => "Name"
      )
    ])
  end

  it "renders a list of chairs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
