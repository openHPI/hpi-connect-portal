require 'spec_helper'

describe "programming_languages/index" do
  before(:each) do
    assign(:programming_languages, [
      stub_model(ProgrammingLanguage,
        :name => "Name"
      ),
      stub_model(ProgrammingLanguage,
        :name => "Name"
      )
    ])
  end

  it "renders a list of programming_languages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
