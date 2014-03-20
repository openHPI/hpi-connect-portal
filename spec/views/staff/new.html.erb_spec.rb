require 'spec_helper'

describe "staff/new" do
  before(:each) do
    @staff = assign(:staff, stub_model(Staff,
      user: stub_model(User,
        firstname: "First Name",
        lastname: "Last Name",
        email: "staff@test.de"
      )
    ).as_new_record)
  end

  it "renders new staff form" do
    render

    assert_select "form[action=?][method=?]", staff_index_path, "post" do
      assert_select "input#staff_user_attributes_email[name=?]", "staff[user_attributes][email]"
      assert_select "input#staff_user_attributes_firstname[name=?]", "staff[user_attributes][firstname]"
      assert_select "input#staff_user_attributes_lastname[name=?]", "staff[user_attributes][lastname]"
    end
  end
end
