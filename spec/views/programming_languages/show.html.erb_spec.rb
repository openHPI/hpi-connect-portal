require 'spec_helper'

describe "programming_languages/show" do
  before(:each) do
    @programming_language = assign(:programming_language, stub_model(ProgrammingLanguage,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
