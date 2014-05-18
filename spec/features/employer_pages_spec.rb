require 'spec_helper'

describe "the employer page" do

  subject { page }

  let(:employer) { FactoryGirl.create(:employer, name: 'EPIC', description: 'A description.', website: 'www.employer.com' ) }
  let(:user) { FactoryGirl.create(:user) }
  let(:staff) { employer.staff_members.first }

  before do
    @student1 = FactoryGirl.create(:student)
    login(@student1.user)

    @job_offer_active = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :active))
    @job_offer_pending = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :pending))
    visit employer_path(employer)
  end

  describe "can be edited" do
    it "by staff members of the employer" do
      staff = FactoryGirl.create(:staff, employer: employer)
      login(staff.user)
      visit employer_path(employer)

      should have_link 'Edit'
      visit edit_employer_path(employer)
      current_path == edit_employer_path(employer)
    end

    it "by an admin" do
      admin = FactoryGirl.create(:user, :admin)
      login(admin)
      visit employer_path(employer)

      should have_link 'Edit'
      visit edit_employer_path(employer)
      current_path == edit_employer_path(employer)
    end

    it "not by student" do
      login(user)
      visit employer_path(employer)

      should_not have_link 'Edit'
      visit edit_employer_path(employer)
      current_path != edit_employer_path(employer)
    end
  end
describe "GET show" do
  describe "can be activated" do

    before :each do 
      @employer = FactoryGirl.create(:employer, activated: false)
    end

    it "by admin" do
      login FactoryGirl.create(:user, :admin)
      visit employer_path(@employer)
      should have_link 'Activate'
    end

    it "not by students" do
      login FactoryGirl.create(:student).user
      get :show, {id: @employer.id}
      response.should redirect_to(root_path)
    end

    it "not by staff members" do
      login FactoryGirl.create(:staff)
      visit employer_path(@employer)
      current_path.should eq root_path
      assert_equal(flash, 'You are not authorized to access this page.')
    end

    it "can also be activated if a new package was booked" do
      @employer.update_column :activated, true
      @employer.update_column :requested_package_id, 1
      login FactoryGirl.create(:user, :admin)
      visit employer_path(@employer)
      should have_link 'Activate'
    end
  end
end

  describe "creating a new employer" do

    it "displays a form to create the first staff member as admin" do
      admin = FactoryGirl.create(:user, :admin)
      login(admin)
      visit new_employer_path

      should have_css("input#employer_staff_members_attributes_0_user_attributes_firstname")
    end

    it "should always create an inactive employer" do
      visit new_employer_path

      fill_in 'employer_name', with: 'Test Employer' 
      fill_in 'employer_description', with: 'Desctiption for an Employer.'
      fill_in 'employer_year_of_foundation', with: 1992
      fill_in 'employer_place_of_business', with: 'Potsdam'
      fill_in 'employer_staff_members_attributes_0_user_attributes_firstname', with: 'Max'
      fill_in 'employer_staff_members_attributes_0_user_attributes_lastname', with: 'Mustermann'
      fill_in 'employer_staff_members_attributes_0_user_attributes_email', with: 'staff@test.com'
      fill_in 'employer_staff_members_attributes_0_user_attributes_password', with: 'password'
      fill_in 'employer_staff_members_attributes_0_user_attributes_password_confirmation', with: 'password'
      find('input[type="submit"]').click

      page.should have_content(
        I18n.t('employers.messages.successfully_created'),
        "General information",
        "Max Mustermann"
      )

      employer = Employer.last
      expect(employer.name).to eq('Test Employer')
      expect(employer.activated).to eq(false)      
    end
  end

  describe "editing an existing employer" do
    it "does not have a select for former deputy" do
      admin = FactoryGirl.create(:user, :admin)
      employer = FactoryGirl.create(:employer)
      staff = FactoryGirl.create(:staff, employer: employer)
      login(admin)
      visit edit_employer_path(employer)

      should_not have_select("employer[deputy_id]")
    end
  end

  describe "should show the basic information of the employer" do
    before :each do
      visit employer_path(employer)
    end

    it { should have_content(employer.name) }

    it "but only show the complete profile for paying employers" do
      should_not have_content(employer.description)
      should_not have_content(employer.website)   
      employer.update_column :booked_package_id, 1
      visit employer_path(employer)
      should have_content(employer.description)
      should have_content(employer.website)
    end
  end

  describe "shows open job offers for the employer" do
    it { should have_content('Open') }
    it { should have_content(@job_offer_active.title) }
    it { should have_content(@job_offer_active.start_date) }
  end

  describe "should show the pending job offers" do

    it "not for students" do
      visit employer_path(employer)
      should_not have_content('Pending')
      should_not have_content(@job_offer_pending.title)
    end

    it "not for an employer of another employer" do
      staff = FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer))
      login(staff.user)
      visit employer_path(employer)
      should_not have_content('Pending')
      should_not have_content(@job_offer_pending.title)
    end

    it "for an employer of a paying employer" do
      employer.update_column :booked_package_id, 1
      staff = FactoryGirl.create(:staff, employer: employer)
      login(staff.user)
      visit employer_path(employer)
      should have_content('Pending')
      should have_content(@job_offer_pending.title)
    end
  end
 end
