require 'spec_helper'

describe "the chair page" do

  subject { page }

  let(:chair) { FactoryGirl.create(:chair, name:"EPIC") }
  let(:user) { FactoryGirl.create(:user) }
  let(:deputy) { chair.deputy }

  before do
    @running = FactoryGirl.create(:job_status, name: 'running')
    @open = FactoryGirl.create(:job_status, name: 'open')

    @job_offer_open = FactoryGirl.create(:job_offer, chair: chair, status: FactoryGirl.create(:job_status, name: 'open'))
    @job_offer_running = FactoryGirl.create(:job_offer, chair: chair, status: FactoryGirl.create(:job_status, name: 'running'))

    visit chair_path(chair)
  end

  describe "can be edited" do
    it "by staff members of the chair" do
      staff = FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Staff', level: 2), chair: chair)
      login_as(staff)
      visit chair_path(chair)

      should have_link 'Edit'
    end

    it "by an admin" do
        admin = FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Admin', level: 3))
        login_as(admin)
        visit chair_path(chair)
        
        should have_link 'Edit'
    end

    it "not by student" do
        login_as(user)
        visit chair_path(chair)
        
        should_not have_link 'Edit'
    end
  end

  describe "demote staff" do

    xit "by an admin" do
      FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Staff', level: 2), chair: chair)
      admin = FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Admin', level: 3))
      login_as(admin)
      visit chair_path(chair)
      expect(page).to have_css(".change-role")
      find(".change-role").click
      expect(page).to have_css(".promote")
      # find(".promote").click
      # page.driver.browser.switch_to.alert.accept
      # page.should_not have_css(".change-role")
    end

  end

  describe "should show the basic information of the chair" do
    it { should have_content(chair.name) }
    it { should have_content(chair.description) }
    it { should have_content(chair.head_of_chair) }
    it { should have_content(chair.deputy.email) }
  end

  describe "shows job offers for the chair" do

    it { should have_content('Open') }
    it { should have_content('Running') }

    it { should have_content(@job_offer_open.title) }
    it { should have_content(@job_offer_running.title) }

    it { should have_content(@job_offer_open.start_date) }
    it { should have_content(@job_offer_running.start_date) }

    it { should have_content(@job_offer_open.chair.name) }
    it { should have_content(@job_offer_running.chair.name) }

  end

 end
