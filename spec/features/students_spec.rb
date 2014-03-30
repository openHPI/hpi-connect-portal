require 'spec_helper'

describe "the students page" do

  let(:staff) { FactoryGirl.create(:staff) }

  before(:each) do
    @programming_language = FactoryGirl.create(:programming_language)
    @student1 = FactoryGirl.create(:student, programming_languages: [@programming_language])

    login staff.user
    visit students_path
  end

  describe "as a staff member" do

    it "is not available for students" do
      login staff.user
      visit students_path
      current_path.should_not == students_path
      current_path.should == root_path
    end
  end

  describe "as a student" do

    it "is not available for students" do
      FactoryGirl.create(:job_status, name: 'open')
      login @student1.user
      visit students_path
      current_path.should_not == students_path
      current_path.should == root_path
    end
  end

  describe "as an admin" do

    before(:each) do
      login FactoryGirl.create(:user, :admin)
      visit students_path
    end

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
end

describe "the students editing page" do

  before(:each) do
    @student1 = FactoryGirl.create(:student)
    login @student1.user
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
    fill_in 'student_facebook', with: 'www.faceboook.com/alex'
    find('input[type="submit"]').click

    current_path.should == student_path(@student1)

    page.should have_content(
      I18n.t('users.messages.successfully_updated'),
      "General information",
      "www.faceboook.com/alex"
    )
   end

  it "can be edited by an admin" do
    admin = FactoryGirl.create(:user, :admin)
    login admin
    visit student_path(@student1)

    page.should have_link("Edit")
    page.find_link("Edit").click

    fill_in 'student_facebook', with: 'www.face.com/alex'
    find('input[type="submit"]').click

    current_path.should == student_path(@student1)

    page.should have_content(
      I18n.t('users.messages.successfully_updated'),
      "General information",
      "www.face.com/alex"
    )
  end
end

describe "the students profile page" do

  before(:each) do
    @job_offer =  FactoryGirl.create(:job_offer)
    @student1 = FactoryGirl.create(:student, assigned_job_offers: [@job_offer])
    @student2 = FactoryGirl.create(:student, assigned_job_offers: [@job_offer])

    login @student1.user
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

    it "should not show a reminder if I am activated" do
      @student1.user.update_column :activated, true
      visit student_path(@student1)

      page.should_not have_content(I18n.t("students.activation_reminder"))
      page.should_not have_css('input#open-id-field')
    end

    it "should show a reminder with openID form if I am not activated" do
      @student1.user.update_column :activated, false
      visit student_path(@student1)

      page.should have_content(I18n.t("students.activation_reminder"))
      page.should have_css('input#open-id-field')
    end
  end

  describe "of another students" do
    before(:each) do
      visit student_path(@student2)
    end

    it "should contain all the details of student2" do
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
      visit edit_student_path(@student1)
      current_path != edit_student_path(@student1)
    end

    it "can't be edited by staff members " do
      staff = FactoryGirl.create(:staff)
      login staff.user
      visit edit_student_path(@student1)

      page.should_not have_link('Edit')
    end

    it "should not have a reminder about activation" do
      page.should_not have_content(I18n.t("students.activation_reminder"))
      page.should_not have_css('input#open-id-field')
    end
  end

  describe "as admin" do
    it "should have activate button" do
      login FactoryGirl.create(:user, :admin)
      student = FactoryGirl.create(:student)
      student.user.update_column :activated, false
      visit student_path(student)
      assert current_path == student_path(student)
      page.should have_link 'Activate'
    end
  end
end
