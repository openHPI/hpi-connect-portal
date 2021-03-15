require 'rails_helper'

describe "the staff pages" do

  let(:staff) { FactoryBot.create(:staff, employer: FactoryBot.create(:employer)) }
  let(:admin) { FactoryBot.create(:user, :admin) }

  before(:each) do
    FactoryBot.create(:job_status, :pending)
    FactoryBot.create(:job_status, :active)
    FactoryBot.create(:job_status, :closed)
    @staff1 = FactoryBot.create(:staff)
    @programming_language = FactoryBot.create(:programming_language)
    @student1 = FactoryBot.create(:student, programming_languages: [@programming_language])
    login admin
    visit staff_index_path
  end

  describe "logged in as an admin" do
    it "shows only names of a staff member on the overview" do
      expect(page).to have_content(@staff1.firstname)
      expect(page).to have_content(@staff1.lastname)
    end

    it "contains a link thats leads to profile page" do
      find_link(@staff1.firstname).click

      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(staff_path(@staff1))
    end

    it "is possible to delete staff members" do
      count_staffs = Staff.all.size
      visit staff_path(@staff1)
      expect(page).to have_content "Delete"
      click_on "Delete"
      expect(Staff.all.size).to eq(count_staffs-1)
    end
  end

  describe "logged in as a member of staff" do
    it "is not visible" do
      FactoryBot.create(:job_status, name: 'active')
      login @staff1.user
      visit staff_index_path
      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(root_path)
    end

    it "is not possible to remove other staff members" do
      staff2 = FactoryBot.create(:staff)
      login staff2
      visit staff_path(@staff1)
      expect(page).to_not have_content "Delete"
    end
  end

   describe "logged in as a student" do
    it "is not visible" do
      FactoryBot.create(:job_status, name: 'active')
      login @student1.user
      visit staff_index_path
      expect(current_path).not_to eq(staff_index_path)
      expect(current_path).to eq(root_path)
    end

    it "is not possible to remove staff members" do
      login @student1.user
      visit staff_path(@staff1)
      expect(page).to_not have_content "Delete"
    end
  end

  describe "New staff after invitation" do
    let(:employer) { FactoryBot.create(:employer, activated: true) }

    it "registers colleague to the employer" do
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

    it "shows an error message when trying to create a staff member that already exists" do
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
      expect(page).to have_content "Login Mail Address has already been taken"
    end
  end
end
