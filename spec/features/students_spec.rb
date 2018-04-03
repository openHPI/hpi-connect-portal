require 'rails_helper'

describe "the students index page" do
  let!(:student) { FactoryBot.create(:student) }
  let(:staff) { FactoryBot.create(:staff, :of_premium_employer) }

  before(:each) do
    login staff.user
    visit students_path
  end

  it "shows student names" do
    expect(page).to have_content(student.firstname)
    expect(page).to have_content(student.lastname)
  end

  it "links to student profile pages" do
    find_link(student.firstname).click
    expect(current_path).to eq(student_path(student))
  end
end

describe "the students editing page" do
  let(:student) { FactoryBot.create(:student) }

  before(:each) do
    login student.user
  end

  it "should contain all attributes of a student" do
    visit edit_student_path(student)
    expect(page).to have_content("HPI-Status")
    expect(page).to have_content("#{student.firstname} #{student.lastname}")
    expect(page).to have_content("Photo")
    expect(page).to have_content("Links")
    expect(page).to have_content("Programming language skills")
    expect(page).to have_content("Additional information")
    expect(page).to have_content("Language skills")
    expect(page).to have_content("Semester")
    expect(page).to have_content("Resume")
  end

  it "should be possible to change attributes of myself " do
    visit edit_student_path(student)
    fill_in 'student_facebook', with: 'www.faceboook.com/alex'
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(student))

    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).to have_content("#{student.firstname} #{student.lastname}")
    expect(page).to have_content("www.faceboook.com/alex")
   end

  it "can be edited by an admin" do
    admin = FactoryBot.create(:user, :admin)
    login admin
    visit student_path(student)

    expect(page).to have_link("Edit")
    page.find_link("Edit").click

    fill_in 'student_facebook', with: 'www.face.com/alex'
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(student))

    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).to have_content("#{student.firstname} #{student.lastname}")
    expect(page).to have_content("www.face.com/alex")
  end
end

describe "the programming languages skills section on the students editing page" do

  let(:student2) { FactoryBot.create(:student) }

  before(:all) do
    @student1 = FactoryBot.create(:student)
    @programming_language1 = FactoryBot.create(:programming_language)
    @programming_language2 = FactoryBot.create(:programming_language)

    @student1.programming_languages_users << FactoryBot.create(:programming_languages_user, student: @student1, programming_language: @programming_language1, skill: 5)
  end

  before(:each) do
    login @student1.user
    visit edit_student_path(@student1)
  end

  it "is possible to add a new skill", js: true do
    skip
    page.select(@programming_language2.name, from: 'add_new_programming_language')
    all('div.row', text: @programming_language2.name).last.first('.star').click
    page.execute_script "window.scrollTo(0,0)"
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(@student1))
    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).to have_content(@programming_language2.name)
    expect(find(:css, "input[type='radio'][name='" + @programming_language2.name + "'][value='1']", visible: false)).to be_checked
    expect(find(:css, "input[type='radio'][name='" + @programming_language2.name + "'][value='2']", visible: false)).not_to be_checked
  end

  it "is possible to remove a skill", js: true do
    skip
    all('div.row', text: @programming_language1.name).last.find('.rating-cancel').click
    page.execute_script "window.scrollTo(0,0)"
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(@student1))
    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).not_to have_content(@programming_language1.name)
  end

  it "is possible to change an existing skill", js: true do
    skip
    all('div.row', text: @programming_language1.name).last.first('.star').click
    page.execute_script "window.scrollTo(0,0)"
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(@student1))
    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).to have_content(@programming_language1.name)
    expect(find(:css, "input[type='radio'][name='" + @programming_language1.name + "'][value='1']", visible: false)).to be_checked
    expect(find(:css, "input[type='radio'][name='" + @programming_language1.name + "'][value='2']", visible: false)).not_to be_checked
  end

  it "is possible to add a new skill in a new programming language", js: true do
    skip
    page.select('Other', from: 'add_new_programming_language')
    input_container_div = find('div.student_programming_languages_users_programming_language_name')
    input_container_div.find('input').set 'New programming language'
    input_container_div.find(:xpath, '../..').first('.star').click
    page.execute_script "window.scrollTo(0,0)"
    first('input[type="submit"]').click

    expect(current_path).to eq(student_path(@student1))
    expect(page).to have_content(I18n.t('users.messages.successfully_updated'))
    expect(page).to have_content("New programming language")
    expect(find(:css, "input[type='radio'][name='New programming language'][value='1']", visible: false)).to be_checked
    expect(find(:css, "input[type='radio'][name='New programming language'][value='2']", visible: false)).not_to be_checked

    login student2.user
    visit edit_student_path(student2)
    expect(page).not_to have_content("New programming language")
  end
end

describe "the students profile page" do

  before(:all) do
    FactoryBot.create(:job_status, :active)
  end

  before(:each) do
    FactoryBot.create(:job_status, :pending)
    FactoryBot.create(:job_status, :active)
    FactoryBot.create(:job_status, :closed)

    @job_offer =  FactoryBot.create(:job_offer)
    @student1 = FactoryBot.create(:student, assigned_job_offers: [@job_offer])
    @student2 = FactoryBot.create(:student, assigned_job_offers: [@job_offer], visibility_id:2)
    @student3 = FactoryBot.create(:student, visibility_id:0)

    login @student1.user
  end

  describe "of myself" do
    before(:each) do
      visit student_path(@student1)
    end

    it "should contain all the details of student1" do
      expect(page).to have_content(@student1.firstname)
      expect(page).to have_content(@student1.lastname)
    end

    it "should contain all jobs I am assigned to" do
      expect(page).to have_content(@job_offer.title)
    end

    it "should have an edit link which leads to the students edit page" do
      visit student_path(@student1)
      page.find_link('Edit').click
      expect(page.current_path).to eq(edit_student_path(@student1))
    end

    it "should not show a reminder if I am activated" do
      @student1.user.update_column :activated, true
      visit student_path(@student1)

      expect(page).not_to have_content(I18n.t("students.activation_reminder"))
      expect(page).not_to have_css('input#open-id-field')
    end

    it "should show a reminder with openID form if I am not activated" do
      @student1.user.update_column :activated, false
      visit student_path(@student1)

      expect(page).to have_content(I18n.t("students.activation_reminder"))
      expect(page).to have_css('input#open-id-field')
    end

    it "should not show Dschool Status if I don't have one" do
      expect(page).not_to have_content("D-School Status")
    end

    it "should show Dschool Status if there is one" do
      @student1.update(dschool_status_id: 1)
      visit student_path(@student1)
      expect(page).to have_content("D-School Status")
    end
  end

  describe "of another students" do
      before(:each) do
        visit student_path(@student3)
    end

    it "should not contain all the details of student3" do
      expect(page).not_to have_content(@student3.firstname)
      expect(page).not_to have_content(@student3.lastname)
    end

  end
  describe "of another students" do
    before(:each) do
      visit student_path(@student2)
    end


    it "should contain all the details of student2" do
      expect(page).to have_content(@student2.firstname)
      expect(page).to have_content(@student2.lastname)
    end

    it "should not contain the job the other student is assigned to" do
      expect(page).not_to have_content(@job_offer.title)
    end

    it "should not have an edit link on the show page of someone elses profile" do
      is_expected.not_to have_link('Edit')
      visit edit_student_path(@student1)
      current_path != edit_student_path(@student1)
    end

    it "can't be edited by staff members " do
      staff = FactoryBot.create(:staff)
      login staff.user
      visit edit_student_path(@student1)

      expect(page).not_to have_link('Edit')
    end

    it "should not have a reminder about activation" do
      expect(page).not_to have_content(I18n.t("students.activation_reminder"))
      expect(page).not_to have_css('input#open-id-field')
    end
  end

  describe "as a member of the staff" do
    before :each do
      @student = FactoryBot.create(:student)
      @employer = FactoryBot.create(:employer)
      @staff = FactoryBot.create(:staff, employer: @employer)
      login @staff.user
    end

    it "should not be accessible for staff of free or partner employers" do
      visit student_path(@student)
      expect(current_path).not_to eq(student_path(@student))
      expect(current_path).to eq(root_path)
      @employer.update_column :booked_package_id, 2
      visit student_path(@student)
      expect(current_path).not_to eq(student_path(@student))
      expect(current_path).to eq(root_path)
    end

    it "should not be accessible for staff of premium employers if student is not visible for him" do
      @employer.update_column :booked_package_id, 3
      @student.update_column :visibility_id, 0
      visit student_path(@student)
      expect(current_path).not_to eq(student_path(@student))
    end

    it "should be accessible for staff of premium employers if student is visibile for him" do
      @employer.update_column :booked_package_id, 3
      @student.update_column :visibility_id, 2
      visit student_path(@student)
      expect(current_path).to eq(student_path(@student))
    end

  end

  describe "as admin" do
    it "should have activate button" do
      login FactoryBot.create(:user, :admin)
      student = FactoryBot.create(:student)
      student.user.update_column :activated, false
      visit student_path(student)
      assert current_path == student_path(student)
      expect(page).to have_link 'Activate'
    end
  end
end

describe "student newsletters" do

  before(:each) do
    employer = FactoryBot.create(:employer, name:"Test Company")
    FactoryBot.create(:job_offer, state_id: 2,
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
    student = FactoryBot.create(:student)
    login student.user
    visit job_offers_path
    select "HPI Student", from: "student_group"
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
    expect(student.newsletter_orders.count).to eq(1)
    expect(student.newsletter_orders.first.search_params.count).to eq(9)
  end
end

describe "student filtering by employer" do
  before(:each) do
    job1 = FactoryBot.create(:cv_job, employer: "SAP")
    @student1 = FactoryBot.create(:student, cv_jobs: [job1])
    job2 = FactoryBot.create(:cv_job, employer: "SAP AG")
    @student2 = FactoryBot.create(:student, cv_jobs: [job2])
    job3 = FactoryBot.create(:cv_job, employer: "HPI")
    @student3 = FactoryBot.create(:student, cv_jobs: [job3])
  end

  it "works for one specified employer" do
    login FactoryBot.create(:user, :admin)
    visit students_path
    fill_in "employer", with: "SAP"
    click_on "Go!"
    expect(page).to have_content @student1.full_name
    expect(page).to_not have_content @student2.full_name
    expect(page).to_not have_content @student3.full_name
  end

  it "works for more specified employers" do
    login FactoryBot.create(:user, :admin)
    visit students_path
    fill_in "employer", with: "SAP,SAP AG"
    click_on "Go!"
    expect(page).to have_content @student1.full_name
    expect(page).to have_content @student2.full_name
    expect(page).to_not have_content @student3.full_name
  end
end

describe "student filtering by programming language and language" do
  before(:each) do
    @programming_language_1 = FactoryBot.create(:programming_language)
    @programming_language_2 = FactoryBot.create(:programming_language)
    @language_1 = FactoryBot.create(:language)
    @language_2 = FactoryBot.create(:language)

    @student1 = FactoryBot.create(:student, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1])
    @student2 = FactoryBot.create(:student, programming_languages: [@programming_language_1], languages: [@language_1, @language_2])
    @student3 = FactoryBot.create(:student, programming_languages: [@programming_language_2], languages: [@language_1])
    @student4 = FactoryBot.create(:student, programming_languages: [@programming_language_2], languages: [@language_2])
    @student5 = FactoryBot.create(:student, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1, @language_2])
  end

  it "finds all users with the requested programming language, and language" do
    login FactoryBot.create(:user, :admin)
    visit students_path
    check "programming_language_#{@programming_language_1.id}"
    check "language_#{@language_1.id}"
    click_on "Go!"
    expect(page).to have_content @student1.full_name
    expect(page).to have_content @student2.full_name
    expect(page).to_not have_content @student3.full_name
    expect(page).to_not have_content @student4.full_name
    expect(page).to have_content @student5.full_name
  end
end
