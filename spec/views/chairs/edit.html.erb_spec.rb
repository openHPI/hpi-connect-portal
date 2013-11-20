require 'spec_helper'

describe "chairs/edit" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair,
      :name => "MyString"
    ))
    @users = User.all
  end

  it "renders the edit chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", chair_path(@chair), "post" do
      assert_select "input#chair_name[name=?]", "chair[name]"
    end
  end
end
