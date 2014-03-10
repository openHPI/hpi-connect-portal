require 'spec_helper'

describe "staff/edit" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      user: stub_model(User,
        firstname: "First Name",
        lastname: "Last Name",
        email: "staff@test.de"
      )
    ))
  end

  it "renders the edit staff form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", staff_path(@staff.id), "post" do
      assert_select "input#staff_user_attributes_email[name=?]", "staff[user_attributes][email]"
      assert_select "input#staff_user_attributes_firstname[name=?]", "staff[user_attributes][firstname]"
      assert_select "input#staff_user_attributes_lastname[name=?]", "staff[user_attributes][lastname]"
    end
  end
end
