require 'rails_helper'

describe Admin::ConfigurablesController do

  let(:staff) { FactoryBot.create(:staff, employer: FactoryBot.create(:employer)) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:student) { FactoryBot.create(:student) }

  it "should not be visible for a member of the staff " do
    login(staff.user)
    visit admin_configurable_path
    expect(current_path).to eq root_path
  end

  it "should not be visible for a student " do
    login(student.user)
    visit admin_configurable_path
    expect(current_path).to eq root_path
  end

  it "should be editable for an admin" do
    login(admin)
    visit admin_configurable_path
    expect(current_path).to eq admin_configurable_path
    find('input[value="Save"]')
  end
end