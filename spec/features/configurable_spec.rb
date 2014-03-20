require 'spec_helper'

describe Admin::ConfigurablesController do

  let(:staff) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:student) { FactoryGirl.create(:student) }

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
  end

  it "should not be visible for a member of the staff " do
    login(staff.user)
    visit admin_configurable_path
    current_path.should eq root_path
  end

  it "should not be visible for a student " do
    login(student.user)
    visit admin_configurable_path
    current_path.should eq root_path
  end

  it "should be editable for an admin" do
    login(admin)
    visit admin_configurable_path
    current_path.should eq admin_configurable_path
    find('input[value="Save"]') 
  end
end