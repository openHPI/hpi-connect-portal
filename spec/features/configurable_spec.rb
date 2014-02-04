require 'spec_helper'

describe Admin::ConfigurablesController do

  let(:staff) { FactoryGirl.create(:user, :staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:student) { FactoryGirl.create(:user, :student) }

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
  end

  it "should not be visible for a member of the staff " do
    login_as(staff, :scope => :user)
    visit admin_configurable_path
    current_path.should eq job_offers_path
  end

  it "should not be visible for a student " do
    login_as(student, :scope => :user)
    visit admin_configurable_path
    current_path.should eq job_offers_path
  end

  it "should be editable for an admin" do
    login_as(admin, :scope => :user)
    visit admin_configurable_path
    current_path.should eq admin_configurable_path
    find('input[value="Save"]') 
  end
end