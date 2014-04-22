require 'spec_helper'

describe "employers/edit" do
  before(:each) do
    @employer = assign(:employer, stub_model(Employer,
      :name => "HCI", :description => "Human Computer Interaction"
    ))
  end

  it "renders the edit employer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", employer_path(@employer), "post" do
      assert_select "input#employer_name[name=?]", "employer[name]"
      assert_select "textarea#employer_description[name=?]", "employer[description]"
    end
  end
end
