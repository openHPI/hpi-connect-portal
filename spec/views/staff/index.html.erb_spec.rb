require 'rails_helper'

describe "staff/index" do
  before(:each) do
    @staff_member_1 = FactoryBot.create(:staff)
    @staff_member_2 = FactoryBot.create(:staff)
    assign(:staff_members, [@staff_member_1, @staff_member_2])
    allow(view).to receive(:current_user) { FactoryBot.create(:staff).user }
  end

  it "renders a list of students" do
    allow(view).to receive(:will_paginate)
    render
    assert_select "a", text: @staff_member_1.firstname + " " + @staff_member_1.lastname, count: 1
    assert_select "a", text: @staff_member_2.firstname + " " + @staff_member_2.lastname, count: 1
  end
end
