require 'spec_helper'

describe "user_statuses/edit" do
  before(:each) do
    @user_status = assign(:user_status, stub_model(UserStatus,
      :name => "MyString"
    ))
  end

  it "renders the edit user_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_status_path(@user_status), "post" do
      assert_select "input#user_status_name[name=?]", "user_status[name]"
    end
  end
end
