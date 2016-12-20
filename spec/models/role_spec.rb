# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  level      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Role do
  it "checks for the student role" do
    assert FactoryGirl.create(:role, name: "Student").student_role?
  end

  it "checks for the staff role" do
    assert FactoryGirl.create(:role, name: "Staff").staff_role?
  end

  it "checks for the admin role" do
    assert FactoryGirl.create(:role, name: "Admin").admin_role?
  end
end
