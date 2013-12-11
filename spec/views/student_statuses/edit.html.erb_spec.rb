require 'spec_helper'

describe "student_statuses/edit" do
  before(:each) do
    @student_status = assign(:student_status, stub_model(StudentStatus,
      :description => "MyString"
    ))
  end

  it "renders the edit student_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", student_status_path(@student_status), "post" do
      assert_select "input#student_status_description[name=?]", "student_status[description]"
    end
  end
end
