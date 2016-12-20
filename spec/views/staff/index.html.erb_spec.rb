require 'spec_helper'

describe "staff/index" do
  before(:each) do
    @staff_member_1 = FactoryGirl.create(:staff)
    @staff_member_2 = FactoryGirl.create(:staff)
    assign(:staff_members, [@staff_member_1, @staff_member_2])
    view.stub(:current_user) { FactoryGirl.create(:staff).user }
  end

  it "renders a list of students" do
    view.stub(:will_paginate)
    render
    assert_select "a", text: @staff_member_1.firstname + " " + @staff_member_1.lastname, count: 1
    assert_select "a", text: @staff_member_2.firstname + " " + @staff_member_2.lastname, count: 1
  end
end
