require 'spec_helper'

describe "chairs/new" do
  before(:each) do
    assign(:chair, stub_model(Chair,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", chairs_path, "post" do
      assert_select "input#chair_name[name=?]", "chair[name]"
    end
  end
end
