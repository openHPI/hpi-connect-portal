require 'spec_helper'

describe "student_statuses/index" do
  before(:each) do
    assign(:student_statuses, [
      stub_model(StudentStatus,
        :description => "Description"
      ),
      stub_model(StudentStatus,
        :description => "Description"
      )
    ])
  end

  it "renders a list of student_statuses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
