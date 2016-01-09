require 'spec_helper'

describe "staff/index" do
  before(:each) do
    assign(:staff_members, [
      stub_model(Staff,
        user: stub_model(User,
          firstname: "First Name",
          lastname: "Last Name",
          email: "staff1@test.de"
        )
      ),
      stub_model(Staff,
        user: stub_model(User,
          firstname: "First Name",
          lastname: "Last Name",
          email: "staff2@test.de"
        )
      )
    ])
    view.stub(:current_user) { FactoryGirl.create(:staff).user }
  end

  it "renders a list of students" do
    view.stub(:will_paginate)
    render
    assert_select "a", text: "First Name Last Name", count: 2
  end
end
