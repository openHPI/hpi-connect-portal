require 'rails_helper'

describe "the employer pages" do
  let(:employer) { FactoryBot.create(:employer, name: 'Cool Employer', description: 'A description.', website: 'www.employer.com' ) }
  let(:staff) { employer.staff_members.first }
  let!(:job_offer_active) { FactoryBot.create(:job_offer, employer: employer, status: JobStatus.active) }
  let!(:job_offer_pending) { FactoryBot.create(:job_offer, employer: employer, status: JobStatus.pending, release_date: nil) }
  let!(:job_offer_closed) { FactoryBot.create(:job_offer, employer: employer, status: JobStatus.closed) }

  describe "editing an employer" do
    context "as a staff member" do
      before(:each) do
        login staff.user
      end

      it "updates employer attributes" do
        visit employer_path(employer)
        expect(page).to have_link 'Edit'
        click_link 'Edit'
        fill_in 'employer_description_en', with: 'New and shiny description.'
        find('input[type="submit"]').click
        expect(employer.reload.description).to eq('New and shiny description.')
      end
    end
  end

  describe "activating an employer" do
    let(:employer_tba) { FactoryBot.create(:employer, activated: false) }

    context "as an admin" do
      before(:each) do
        login FactoryBot.create(:user, :admin)
      end

      it "activates the employer" do
        visit employer_path(employer_tba)
        expect(page).to have_link 'Activate'
        click_link 'Activate'
        expect(employer_tba.reload.activated).to eq(true)
        expect(page).to have_content(I18n.t('employers.messages.successfully_activated'))
      end

      context "if a new package was requested" do
        before(:each) do
          employer_tba.update_column :requested_package_id, 1
          ActionMailer::Base.deliveries = []
        end

        it "updates the booked package" do
          visit employer_path(employer_tba)
          expect(page).to have_link 'Activate'
          click_link 'Activate'
          expect(employer_tba.reload.booked_package_id).to eq(1)
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          expect(page).to have_content(I18n.t('employers.messages.successfully_activated'))
        end
      end
    end
  end

  describe "creating a new employer" do
    it "creates an employer that is not activated" do
      visit new_employer_path

      fill_in 'employer_name', with: 'Test Employer'
      fill_in 'employer_description_en', with: 'Description for an Employer.'
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

  describe "viewing an employer profile" do
    context "as a student" do
      before(:each) do
        login FactoryBot.create(:student)
        visit employer_path(employer)
      end

      it "shows employer's open job offers" do
        expect(page).to have_content(I18n.t('employers.active_job_offers'))
        expect(page).to have_content(job_offer_active.title)
        expect(page).to have_content(job_offer_active.release_date)
      end

      it "shows employer's basic information" do
        expect(page).to have_content(employer.name)
        expect(page).not_to have_content(employer.description)
        expect(page).not_to have_content(employer.website)
      end

      it "shows the complete profile for paying employers" do
        employer.update_column :booked_package_id, 1
        visit employer_path(employer)
        expect(page).to have_content(employer.description)
        expect(page).to have_content(employer.website)
      end

      it "doesn't show pending job offers" do
        visit employer_path(employer)
        expect(page).not_to have_content('Pending')
        expect(page).not_to have_content(job_offer_pending.title)
      end

      it "shows closed job offers" do
        expect(page).to have_content(I18n.t('employers.closed_job_offers'))
        expect(page).to have_content(job_offer_closed.title)
        expect(page).to have_content(job_offer_closed.release_date)
      end

      it "doesn't link to closed job offers" do
        expect(page).not_to have_link(job_offer_closed.title)
      end

      it "shows an externel website link for the employer website, even if it doesn't begin with http://" do
        employer.update_column :booked_package_id, 1
        employer.update_column :website, "test.de"
        visit employer_path(employer)
        expect(page).to have_link( nil , href: 'http://test.de')
      end
    end

    context "as a staff member of another employer" do
      before(:each) do
        login FactoryBot.create(:staff, employer: FactoryBot.create(:employer)).user
        visit employer_path(employer)
      end

      it "doesn't show pending job offers" do
        expect(page).not_to have_content(I18n.t('employers.pending_job_offers'))
        expect(page).not_to have_content(job_offer_pending.title)
      end

      it "doesn't link to closed job offers" do
        expect(page).not_to have_link(job_offer_closed.title)
      end
    end

    context "as a staff member" do
      before(:each) do
        login staff.user
        visit employer_path(employer)
        #employer.update_column :booked_package_id, 1
      end

      it "shows pending job offers" do
        expect(page).to have_content(I18n.t('employers.pending_job_offers'))
        expect(page).to have_content(job_offer_pending.title)
      end

      it "links to closed job offers" do
        expect(page).to have_link(job_offer_closed.title)
      end
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
