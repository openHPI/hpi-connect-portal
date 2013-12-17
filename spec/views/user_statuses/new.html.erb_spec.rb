require 'spec_helper'

describe "user_statuses/new" do
  before(:each) do
    assign(:user_status, stub_model(UserStatus,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new user_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_statuses_path, "post" do
      assert_select "input#user_status_name[name=?]", "user_status[name]"
    end
  end
end
