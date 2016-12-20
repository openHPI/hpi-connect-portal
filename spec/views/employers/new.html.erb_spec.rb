require 'spec_helper'

describe "employers/new" do
  before(:each) do
    @employer = assign(:employer, Employer.new)
  end

  it "renders new employer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", employers_path, "post" do
      assert_select "input#employer_name[name=?]", "employer[name]"
      assert_select "textarea#employer_description[name=?]", "employer[description]"
    end
  end
end
