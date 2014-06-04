require 'spec_helper'

describe "the staff page" do

  let(:staff) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before(:all) do 
    FactoryGirl.create(:job_status, :active)
  end

	before(:each) do
    @staff1 = FactoryGirl.create(:staff)
    @programming_language = FactoryGirl.create(:programming_language)
    @student1 = FactoryGirl.create(:student, programming_languages: [@programming_language])
    login admin
    visit staff_index_path
  end

  describe "as an admin" do
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

    it "should have a button to demote a member of the staff " do
      #should have_button('Demote')
    end
  end
  

  describe "as a member of staff" do

    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'active')
      login @staff1.user
      visit staff_index_path
      current_path.should_not == staff_index_path
      current_path.should == root_path
    end
  end

   describe "as a student" do

    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'active')
      login @student1.user
      visit staff_index_path
      current_path.should_not == staff_index_path
      current_path.should == root_path
    end

  end
end
