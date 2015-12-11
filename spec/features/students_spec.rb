require 'spec_helper'

describe "the students page" do

  let(:staff) { FactoryGirl.create(:staff) }

  before(:all){
    FactoryGirl.create(:job_status, :active)
  }

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
    @programming_language = FactoryGirl.create(:programming_language)
    @student1 = FactoryGirl.create(:student, programming_languages: [@programming_language])
    login staff.user
    visit students_path
  end

  describe "as a staff member" do

    it "is not available for staff members of not paying employers" do
      login staff.user
      visit students_path
      current_path.should_not == students_path
      current_path.should == root_path
      staff.employer.update_column :booked_package_id, 2
      visit students_path
      current_path.should_not == students_path
      current_path.should == root_path
    end

    it "is available for staff members of premium employers" do
      staff.employer.update_column :booked_package_id, 3
      login staff.user
      visit students_path
      current_path.should == students_path
    end
  end

  describe "as a student" do

    it "is available for students" do
      login FactoryGirl.create(:student).user
      visit students_path
      current_path.should == students_path
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

  before(:all) do
    FactoryGirl.create(:job_status, :active)
  end

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
    @student1 = FactoryGirl.create(:student)
    login @student1.user
  end

  it "should contain all attributes of a student" do
    visit edit_student_path(@student1)
    page.should have_content(
      "HPI-Status",
      "General Information",
      "Photo",
      "Links",
      "Programming language skills",
      "Additional information",
      "Language skills",
      "Python",
      "English",
      "Picture",
      "Semester",
      "Resume"
    )
  end

  it "should be possible to change attributes of myself " do
    visit edit_student_path(@student1)
    fill_in 'student_facebook', with: 'www.faceboook.com/alex'
    first('input[type="submit"]').click

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
    first('input[type="submit"]').click

    current_path.should == student_path(@student1)

    page.should have_content(
      I18n.t('users.messages.successfully_updated'),
      "General information",
      "www.face.com/alex"
    )
  end
end

describe "the students profile page" do

  before(:all) do
    FactoryGirl.create(:job_status, :active)
  end

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)

    @job_offer =  FactoryGirl.create(:job_offer)
    @student1 = FactoryGirl.create(:student, assigned_job_offers: [@job_offer])
    @student2 = FactoryGirl.create(:student, assigned_job_offers: [@job_offer], visibility_id:2)
    @student3 = FactoryGirl.create(:student, visibility_id:0)

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

    it "should not show Dschool Status if I don't have one" do
      page.should_not have_content("D-School Status")
    end

    it "should show Dschool Status if there is one" do
      @student1.update(dschool_status_id: 1)
      visit student_path(@student1)
      page.should have_content("D-School Status")
    end
  end

  describe "of another students" do
      before(:each) do
        visit student_path(@student3)
    end

    it "should not contain all the details of student3" do
        page.should_not have_content(
          @student3.firstname,
          @student3.lastname
        )
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

  describe "as a member of the staff" do
    before :each do
      @student = FactoryGirl.create(:student)
      @employer = FactoryGirl.create(:employer)
      @staff = FactoryGirl.create(:staff, employer: @employer)
      login @staff.user
    end

    it "should not be accessible for staff of free or partner employers" do
      visit student_path(@student)
      current_path.should_not == student_path(@student)
      current_path.should == root_path
      @employer.update_column :booked_package_id, 2
      visit student_path(@student)
      current_path.should_not == student_path(@student)
      current_path.should == root_path
    end

    it "should not be accessible for staff of premium employers if student is not visible for him" do
      @employer.update_column :booked_package_id, 3
      @student.update_column :visibility_id, 0
      visit student_path(@student)
      current_path.should_not == student_path(@student)
    end

    it "should be accessible for staff of premium employers if student is visibile for him" do
      @employer.update_column :booked_package_id, 3
      @student.update_column :visibility_id, 2
      visit student_path(@student)
      current_path.should == student_path(@student)
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

describe "student newsletters" do

  before(:each) do
    employer = FactoryGirl.create(:employer, name:"Test Company")
    FactoryGirl.create(:job_offer, state_id: 2,
                       employer: employer,
                       status: JobStatus.active,
                       start_date: Date.current,
                       end_date: Date.current + 14,
                       compensation: 20,
                       time_effort: 20,
                       category_id: 2,
                       graduation_id: 0,
                      )
  end

  it "creates newsletter_order" do
    student = FactoryGirl.create(:student)
    login student.user
    visit job_offers_path
    select "Test Company", from: "employer"
    select "Bavaria", from: "state"
    select "Job for graduates", from: "category"
    select "General Qualification for University Entrance", from: "graduation"
    fill_in "start_date", with: Date.current
    fill_in "end_date", with: Date.current + 14
    fill_in "compensation", with: 20
    fill_in "time_effort", with: 20
    page.find("#create_newsletter_button").click
    page.find("#newsletter_creation_submit").click
    student.newsletter_orders.count.should == 1
    student.newsletter_orders.first.search_params.count.should == 8
  end
end
