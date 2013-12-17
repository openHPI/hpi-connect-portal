require 'spec_helper'

describe "chairs/new" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair,
      :name => "HCI", :description => "Human Computer Interaction", :head_of_chair => "Prof. Patrick Baudisch"
    ).as_new_record)
  end

  it "renders new chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", chairs_path, "post" do
      assert_select "input#chair_name[name=?]", "chair[name]"
      assert_select "textarea#chair_description[name=?]", "chair[description]"
      assert_select "input#chair_head_of_chair[name=?]", "chair[head_of_chair]"
    end
  end
end
