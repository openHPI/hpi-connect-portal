require 'spec_helper'

describe "the students page" do

  let(:staff) { FactoryGirl.create(:user, :staff) }

  before(:each) do
    @programming_language = FactoryGirl.create(:programming_language)
    @student1 = FactoryGirl.create(:user, :student, :programming_languages =>[@programming_language])
    login_as(staff, :scope => :user)

    FactoryGirl.create(:role, :admin)

    login_as(staff, :scope => :user)
    visit students_path
  end

  describe "as a staff member" do 

      it "should view only names and status of a student on the overview" do
        page.should have_content(
          @student1.firstname,
          @student1.lastname
        )
       
      end

      it "should contain a link for showing a profile and it should lead to profile page " do
        find_link(@student1.firstname).click
        current_path.should_not == students_path
        current_path.should == student_path(@student1)
      end
  end

  describe "as a student" do

    it "is not available for students" do
      FactoryGirl.create(:job_status, name: 'open')
      login_as(@student1, :scope => :user)
      visit students_path
      current_path.should_not == students_path
      current_path.should == job_offers_path
    end
  end

  describe "as an admin" do

      it "should view only names and status of a student on the overview" do
        page.should have_content(
          @student1.firstname,
          @student1.lastname
        )
        #page.should have_link('Promote')
      end

      it "should contain a link for showing a profile and it should lead to profile page " do
        find_link(@student1.firstname).click
        current_path.should_not == students_path
        current_path.should == student_path(@student1)
      end
  end


end


describe "the students editing page" do

  before(:each) do
    @student1 = FactoryGirl.create(:user, :student)
    login_as(@student1, :scope => :user)
  end

  it "should contain all attributes of a student" do
    visit edit_student_path(@student1)
    page.should have_content(
      "Career",
      "General Information",
      "Links",
      "Programming language skills",
      "Additional information",
      "Language skills",
      "Python",
      "English",
      "Picture",
      "Semester"
    )

  end

  it "should be possible to change attributes of myself " do
    visit edit_student_path(@student1)
    fill_in 'user_facebook', :with => 'www.faceboook.com/alex'
    fill_in 'user_email', :with => 'www.alex@hpi.uni-potsdam.de'
    find('input[type="submit"]').click

    current_path.should == student_path(@student1)

    page.should have_content(
      "User was successfully updated",
      "General information",
      "www.alex@hpi.uni-potsdam.de"
    )

   end
end

describe "the students profile page" do

  before(:each) do
    @job_offer =  FactoryGirl.create(:job_offer)
    @student1 = FactoryGirl.create(:user, :student, :assigned_job_offers => [@job_offer])
    @student2 = FactoryGirl.create(:user, :student, :assigned_job_offers => [@job_offer])

    login_as(@student1, :scope => :user)
   end


  describe "of myself" do
    before(:each) do
        visit student_path(@student1)
    end

    it "should contain all the details of student1" do
      page.should have_content(
        @student1.firstname,
        @student1.lastname
      )
    end

    it "should contain all jobs I am assigned to" do
      page.should have_content(@job_offer.title)
    end

    it "should have an edit link which leads to the students edit page" do
      visit student_path(@student1)
      page.find_link('Edit').click
      page.current_path.should == edit_student_path(@student1)
    end
  end

  describe "of another students" do
    before(:each) do
      visit student_path(@student2)
    end

    it "should contain all the details of student1" do
      page.should have_content(
        @student2.firstname,
        @student2.lastname
      )
    end

    it "should not contain the job the other student is assigned to" do
      page.should_not have_content(@job_offer.title)
    end

    it "should not have an edit link on the show page of someone elses profile" do
      should_not have_link('Edit')
    end

    it "can't be edited by staff members " do
      staff = FactoryGirl.create(:user, :staff, employer: FactoryGirl.create(:employer))
      login_as(staff)
      visit edit_student_path(@student1)

      page.should_not have_link('Edit')
    end 

    # it "can be edited by an admin" do
    #   admin = FactoryGirl.create(:user, :admin)
    #   login_as(admin)
    #   visit edit_student_path(@student1)

    #   page.should have_link('Edit')
    # end
  end
end



