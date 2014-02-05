require 'spec_helper'

describe "the employer page" do

  subject { page }

  let(:employer) { FactoryGirl.create(:employer, name: 'EPIC' ) }
  let(:user) { FactoryGirl.create(:user) }
  let(:deputy) { employer.deputy }

  before do
    @student1 = FactoryGirl.create(:user)
    login_as(@student1, :scope => :user)

    @job_offer_open = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :open))
    @job_offer_running = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :running))
    @job_offer_pending = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :pending))
    visit employer_path(employer)
  end

  describe "can be edited" do
    it "by staff members of the employer" do
      staff = FactoryGirl.create(:user, :staff, employer: employer)
      login_as(staff)
      visit employer_path(employer)

      should have_link 'Edit'
      visit edit_employer_path(employer)
      current_path == edit_employer_path(employer)
    end

    it "by an admin" do
        admin = FactoryGirl.create(:user, :admin)
        login_as(admin)
        visit employer_path(employer)

        should have_link 'Edit'
        visit edit_employer_path(employer)
        current_path = edit_employer_path(employer)
    end

    it "not by student" do
        login_as(user)
        visit employer_path(employer)

        should_not have_link 'Edit'
        visit edit_employer_path(employer)
        current_path != edit_employer_path(employer)
    end
  end

  describe "creating a new employer" do

    it "displays a select with all students for selecting the deputy" do
      admin = FactoryGirl.create(:user, :admin)
      login_as(admin)
      visit new_employer_path

      should have_select("employer[deputy_id]", options: [I18n.t("employers.select_deputy")] + User.students.map { |student| student.email })
    end

  end

  describe "editing an existing employer" do
    it "displays a select with all staff members of the employer for selecting the deputy" do
      admin = FactoryGirl.create(:user, :admin)
      employer = FactoryGirl.create(:employer)
      staff = FactoryGirl.create(:user, employer: employer)
      login_as(admin)
      visit edit_employer_path(employer)

      should have_select("employer[deputy_id]", options: employer.staff.map { |staff| staff.email })
    end
  end

  describe "should show the basic information of the employer" do
    it { should have_content(employer.name) }
    it { should have_content(employer.description) }
    it { should have_content(employer.head) }
    it { should have_content(employer.deputy.firstname+" "+employer.deputy.lastname) }

    describe "for an external employer" do
      before do
        @external = FactoryGirl.create(:employer, external: true)
        visit employer_path(@external)
      end

      it { should have_content(I18n.t("employers.external")) }
    end
  end

  describe "shows running and open job offers for the employer" do

    it { should have_content('Open') }
    it { should have_content('Running') }

    it { should have_content(@job_offer_open.title) }
    it { should have_content(@job_offer_running.title) }

    it { should have_content(@job_offer_open.start_date) }
    it { should have_content(@job_offer_running.start_date) }

  end

  describe "should show the pending job offers" do

    it "not for students" do
      visit employer_path(employer)
      should_not have_content('Pending')
      should_not have_content(@job_offer_pending.title)
    end

    it "not for an employer of another chair" do
      staff = FactoryGirl.create(:user, :staff, employer: FactoryGirl.create(:employer))
      login_as(staff)
      visit employer_path(employer)
      should_not have_content('Pending')
      should_not have_content(@job_offer_pending.title)
    end

    it "for an employer of the chair" do
      staff = FactoryGirl.create(:user, :staff, employer: employer)
      login_as(staff)
      visit employer_path(employer)
      should have_content('Pending')
      should have_content(@job_offer_pending.title)
    end

  end
 end
