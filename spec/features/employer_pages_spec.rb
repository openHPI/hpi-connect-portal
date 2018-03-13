require 'rails_helper'

describe "the employer page" do

  subject { page }

  let(:employer) { FactoryBot.create(:employer, name: 'EPIC', description: 'A description.', website: 'www.employer.com' ) }
  let(:user) { FactoryBot.create(:user) }
  let(:staff) { employer.staff_members.first }

  before do
    @student1 = FactoryBot.create(:student)
    login(@student1.user)
    @job_offer_active = FactoryBot.create(:job_offer, employer: employer, status: JobStatus.active)
    @job_offer_pending = FactoryBot.create(:job_offer, employer: employer, status: JobStatus.pending, release_date: nil)
    @job_offer_closed = FactoryBot.create(:job_offer, employer: employer, status: JobStatus.closed)
    visit employer_path(employer)
  end

  describe "can be edited" do
    it "by staff members of the employer" do
      staff = FactoryBot.create(:staff, employer: employer)
      login(staff.user)
      visit employer_path(employer)

      is_expected.to have_link 'Edit'
      visit edit_employer_path(employer)
      current_path == edit_employer_path(employer)
    end

    it "by an admin" do
      admin = FactoryBot.create(:user, :admin)
      login(admin)
      visit employer_path(employer)

      is_expected.to have_link 'Edit'
      visit edit_employer_path(employer)
      current_path == edit_employer_path(employer)
    end

    it "not by student" do
      login(user)
      visit employer_path(employer)

      is_expected.not_to have_link 'Edit'
      visit edit_employer_path(employer)
      current_path != edit_employer_path(employer)
    end
  end

  describe "can be activated" do

    before :each do
      @employer = FactoryBot.create(:employer, activated: false)
    end

    it "by admin" do
      login FactoryBot.create(:user, :admin)
      visit employer_path(@employer)
      is_expected.to have_link 'Activate'
    end

    it "not by students" do
      login FactoryBot.create(:student).user
      visit employer_path(@employer)
      expect(current_path).to eq root_path
      is_expected.to have_content "You are not authorized to access this page."
    end

    it "not by staff members" do
      login FactoryBot.create(:staff)
      visit employer_path(@employer)
      expect(current_path).to eq root_path
      is_expected.to have_content "You are not authorized to access this page."
    end

    it "can also be activated if a new package was booked" do
      @employer.update_column :activated, true
      @employer.update_column :requested_package_id, 1
      login FactoryBot.create(:user, :admin)
      visit employer_path(@employer)
      is_expected.to have_link 'Activate'
    end
  end


  describe "creating a new employer" do

    it "displays a form to create the first staff member as admin" do
      admin = FactoryBot.create(:user, :admin)
      login(admin)
      visit new_employer_path

      is_expected.to have_css("input#employer_staff_members_attributes_0_user_attributes_firstname")
    end

    it "should always create an inactive employer" do
      visit new_employer_path

      fill_in 'employer_name', with: 'Test Employer'
      fill_in 'employer_description_en', with: 'Desctiption for an Employer.'
      fill_in 'employer_year_of_foundation', with: 1992
      fill_in 'employer_place_of_business', with: 'Potsdam'
      fill_in 'employer_staff_members_attributes_0_user_attributes_firstname', with: 'Max'
      fill_in 'employer_staff_members_attributes_0_user_attributes_lastname', with: 'Mustermann'
      fill_in 'employer_staff_members_attributes_0_user_attributes_email', with: 'staff@test.com'
      fill_in 'employer_staff_members_attributes_0_user_attributes_password', with: 'password'
      fill_in 'employer_staff_members_attributes_0_user_attributes_password_confirmation', with: 'password'
      fill_in 'employer_contact_attributes_name', with: 'Max Mustermann'
      fill_in 'employer_contact_attributes_street', with: 'Teststraße'
      fill_in 'employer_contact_attributes_zip_city', with: '12345 Teststadt'
      fill_in 'employer_contact_attributes_email', with: 'mmustermann@testemployer.com'
      find('input[type="submit"]').click

      expect(page).to have_content(I18n.t('employers.messages.successfully_created'))
      expect(page).to have_content("Welcome to HPI Connect!")
      expect(page).to have_content("Max Mustermann")

      employer = Employer.last
      expect(employer.name).to eq('Test Employer')
      expect(employer.activated).to eq(false)
    end
  end

  describe "editing an existing employer" do
    it "does not have a select for former deputy" do
      admin = FactoryBot.create(:user, :admin)
      employer = FactoryBot.create(:employer)
      staff = FactoryBot.create(:staff, employer: employer)
      login(admin)
      visit edit_employer_path(employer)

      is_expected.not_to have_select("employer[deputy_id]")
    end
  end

  describe "should show the basic information of the employer" do
    before :each do
      visit employer_path(employer)
    end

    it { is_expected.to have_content(employer.name) }

    it "but only show the complete profile for paying employers" do
      is_expected.not_to have_content(employer.description)
      is_expected.not_to have_content(employer.website)
      employer.update_column :booked_package_id, 1
      visit employer_path(employer)
      is_expected.to have_content(employer.description)
      is_expected.to have_content(employer.website)
    end
  end

  describe "shows open job offers for the employer" do
    it { is_expected.to have_content('Open') }
    it { is_expected.to have_content(@job_offer_active.title) }
    it { is_expected.to have_content(@job_offer_active.release_date) }
  end

  describe "should show the pending job offers" do

    it "not for students" do
      visit employer_path(employer)
      is_expected.not_to have_content('Pending')
      is_expected.not_to have_content(@job_offer_pending.title)
    end

    it "not for an employer of another employer" do
      staff = FactoryBot.create(:staff, employer: FactoryBot.create(:employer))
      login(staff.user)
      visit employer_path(employer)
      is_expected.not_to have_content('Pending')
      is_expected.not_to have_content(@job_offer_pending.title)
    end

    it "for an employer of a paying employer" do
      employer.update_column :booked_package_id, 1
      staff = FactoryBot.create(:staff, employer: employer)
      login(staff.user)
      visit employer_path(employer)
      is_expected.to have_content('Pending')
      is_expected.to have_content(@job_offer_pending.title)
    end
  end

  describe "should show closed job offers" do
    it { is_expected.to have_content(I18n.t("employers.closed_job_offers")) }
    it { is_expected.to have_content(@job_offer_closed.title) }
    it { is_expected.to have_content(@job_offer_closed.release_date) }

    it "should not have_link for students" do
      is_expected.not_to have_link @job_offer_closed.title
    end

    it "should have link" do
      staff = FactoryBot.create(:staff, employer: @job_offer_closed.employer)
      login staff.user
      visit employer_path(employer)
      is_expected.to have_link @job_offer_closed.title
    end

    it "should not have link for foreign staff" do
      foreign_staff = FactoryBot.create(:staff)
      login foreign_staff.user
      visit employer_path(employer)
      is_expected.not_to have_link @job_offer_closed.title
    end
  end

  describe "Staff invitations" do

    xit "should invite others" do
      # needs Javascript -.-
      Capybara.current_driver = :selenium
      ActionMailer::Base.deliveries = []
      login staff.user
      visit employer_path(employer)
      page.find("#open-popup").click
      save_and_open_page
      fill_in 'Email', with: 'test@test.de'
      page.find("#send_application_button").click
      expect(page).to have_content "Email was send to your colleague"
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      Capybara.use_default_driver
    end

  end
 end
