require 'spec_helper'

describe "the staff page" do

  let(:staff) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

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
  

  describe "as an member of staff" do

    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'open')
      login @staff1.user
      visit staff_index_path
      current_path.should_not == staff_index_path
      current_path.should == job_offers_path
    end
  end

   describe "as an member of staff" do

    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'open')
      login @student1.user
      visit staff_index_path
      current_path.should_not == staff_index_path
      current_path.should == job_offers_path
    end

  end
end

describe "the staffs profile page" do

  let(:staff_role) { FactoryGirl.create(:role, name: 'Staff', level: 2) }

  before(:each) do
    @staff1 = FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer))
    @staff2 = FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer))

    FactoryGirl.create(:job_status, name: 'open')
  end

  describe "as a staff member" do

    before(:each) do
      login @staff1.user
    end

    it "should have an edit link on the show page of the own profile which leads to the staffs edit page" do
        visit staff_path(@staff1)
        page.find_link('Edit').click
        page.current_path.should == edit_staff_path(@staff1)
    end

    it "should not have an edit link on the show page of someone elses profile" do
        visit staff_path(@staff2)
        should_not have_link('Edit')
        visit edit_staff_path(@staff2)
        current_path.should ==  staff_path(@staff2)
    end
  end

  describe "as an admin" do

    it "should be editable" do
        login @staff1.user
        visit staff_path(@staff1)
        page.find_link('Edit').click
        page.current_path.should == edit_staff_path(@staff1)
    end
  end
end
