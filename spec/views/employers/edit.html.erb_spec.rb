require 'rails_helper'

describe "employers/edit" do
  before(:each) do
    @employer = assign(:employer, FactoryGirl.create(:employer))
  end

  it "renders the edit employer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", employer_path(@employer), "post" do
      assert_select "input#employer_name[name=?]", "employer[name]"
      assert_select "textarea#employer_description_en[name=?]", "employer[description_en]"
      assert_select "textarea#employer_description_de[name=?]", "employer[description_de]"
    end
  end
end
