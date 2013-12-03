require 'spec_helper'

describe "student_statuses/new" do
  before(:each) do
    assign(:student_status, stub_model(StudentStatus,
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new student_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", student_statuses_path, "post" do
      assert_select "input#student_status_description[name=?]", "student_status[description]"
    end
  end
end
