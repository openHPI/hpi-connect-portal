require 'spec_helper'

describe "the staff page" do

  let(:staff) { FactoryGirl.create(:user, :staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

	before(:each) do
    @staff1 = FactoryGirl.create(:user, :staff)
    login_as(admin, :scope => :user)
    visit staff_index_path

  end

  it "should view only names of a staff member on the overview" do
    page.should have_content(
      @staff1.firstname,
      @staff1.lastname,
    )
  end

  it "should contain a link for showing a profile and it should lead to profile page " do
    find_link(@staff1.firstname).click
    
    current_path.should_not == staff_index_path
    current_path.should == staff_path(@staff1)
  end

  # it "should have a button to promoto a member of the staff " do
  #   should have_button('Promote')
  # end

  it "should not be visible for a member of the staff " do
    login_as(@staff1, :scope => :user)
    FactoryGirl.create(:job_offer, status: FactoryGirl.create(:job_status, name: 'open')) #see Issue 205
    visit staff_index_path
    current_path.should_not == staff_index_path
    current_path.should == root_path
  end


end