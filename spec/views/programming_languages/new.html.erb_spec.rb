require 'spec_helper'

describe "programming_languages/new" do
  before(:each) do
    assign(:programming_language, stub_model(ProgrammingLanguage,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new programming_language form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", programming_languages_path, "post" do
      assert_select "input#programming_language_name[name=?]", "programming_language[name]"
    end
  end
end
