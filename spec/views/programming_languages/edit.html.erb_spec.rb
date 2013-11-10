require 'spec_helper'

describe "programming_languages/edit" do
  before(:each) do
    @programming_language = assign(:programming_language, stub_model(ProgrammingLanguage,
      :name => "MyString"
    ))
  end

  it "renders the edit programming_language form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", programming_language_path(@programming_language), "post" do
      assert_select "input#programming_language_name[name=?]", "programming_language[name]"
    end
  end
end
