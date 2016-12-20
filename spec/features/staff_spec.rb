require 'rails_helper'

describe "the staff page" do

  let(:staff) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
    @staff1 = FactoryGirl.create(:staff)
    @programming_language = FactoryGirl.create(:programming_language)
    @student1 = FactoryGirl.create(:student, programming_languages: [@programming_language])
    login admin
    visit staff_index_path
  end

  describe "as an admin" do
    it "should view only names of a staff member on the overview" do
      expect(page).to have_content(@staff1.firstname)
      expect(page).to have_content(@staff1.lastname)
    end

    it "should contain a link for showing a profile and it should lead to profile page " do
      find_link(@staff1.firstname).click

      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(staff_path(@staff1))
    end

    it "should have a button to demote a member of the staff " do
      #should have_button('Demote')
    end

    it "should be possible to delete staff members" do
      count_staffs = Staff.all.size
      visit staff_path(@staff1)
      expect(page).to have_content "Delete"
      click_on "Delete"
      expect(Staff.all.size).to eq(count_staffs-1)
    end
  end


  describe "as a member of staff" do
    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'active')
      login @staff1.user
      visit staff_index_path
      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(root_path)
    end

    it "should not remove other staff members" do
      staff2 = FactoryGirl.create(:staff)
      login staff2
      visit staff_path(@staff1)
      expect(page).to_not have_content "Delete"
    end
  end

   describe "as a student" do
    it "should not be visible " do
      FactoryGirl.create(:job_status, name: 'active')
      login @student1.user
      visit staff_index_path
      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(root_path)
    end

    it "should not remove staff members" do
      login @student1.user
      visit staff_path(@staff1)
      expect(page).to_not have_content "Delete"
    end
  end

  describe "New staff after invitation" do
    let(:employer) { FactoryGirl.create(:employer, activated: true) }

    it "should register colleague to the employer" do
      visit new_staff_index_path(token: employer.token)
      fill_in 'staff_user_attributes_firstname', with: 'Max'
      fill_in 'staff_user_attributes_lastname', with: 'Mustermann'
      fill_in 'staff_user_attributes_email', with: 'staff@test.com'
      fill_in 'staff_user_attributes_password', with: 'password'
      fill_in 'staff_user_attributes_password_confirmation', with: 'password'
      find('input[type="submit"]').click
      expect(employer.staff_members.count).to eq(2)
      expect(page).to have_content(I18n.t('employers.messages.successfully_created'))
      expect(page).to have_content("Welcome to HPI Connect!")
      expect(page).to have_content("Max Mustermann")
    end

    it "should show an error message when trying to create a staff member that already exists" do
      2.times do
        visit new_staff_index_path(token: employer.token)
        fill_in 'staff_user_attributes_firstname', with: 'Max'
        fill_in 'staff_user_attributes_lastname', with: 'Mustermann'
        fill_in 'staff_user_attributes_email', with: 'staff@test.com'
        fill_in 'staff_user_attributes_password', with: 'password'
        fill_in 'staff_user_attributes_password_confirmation', with: 'password'
        find('input[type="submit"]').click
        expect(employer.staff_members.count).to eq(2)
      end
      expect(page).to have_content "An error occurred while trying to create the staff member. Are you sure the member doesn't already exist?"
    end
  end
end
