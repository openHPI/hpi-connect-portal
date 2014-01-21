require 'spec_helper'

describe "the employer page" do

  subject { page }

  let(:employer) { FactoryGirl.create(:employer, name:"EPIC") }
  let(:user) { FactoryGirl.create(:user) }
  let(:deputy) { employer.deputy }

  before do
    @running = FactoryGirl.create(:job_status, name: 'running')
    @open = FactoryGirl.create(:job_status, name: 'open')

    @job_offer_open = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, name: 'open'))
    @job_offer_running = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, name: 'running'))

    visit employer_path(employer)
  end

  describe "can be edited" do
    it "by staff members of the employer" do
      staff = FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Staff', level: 2), employer: employer)
      login_as(staff)
      visit employer_path(employer)

      should have_link 'Edit'
    end

    it "by an admin" do
        admin = FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Admin', level: 3))
        login_as(admin)
        visit employer_path(employer)
        
        should have_link 'Edit'
    end

    it "not by student" do
        login_as(user)
        visit employer_path(employer)
        
        should_not have_link 'Edit'
    end
  end

  describe "should show the basic information of the employer" do
    it { should have_content(employer.name) }
    it { should have_content(employer.description) }
    it { should have_content(employer.head) }
    it { should have_content(employer.deputy.email) }
  end

  describe "shows job offers for the employer" do

    it { should have_content('Open') }
    it { should have_content('Running') }

    it { should have_content(@job_offer_open.title) }
    it { should have_content(@job_offer_running.title) }

    it { should have_content(@job_offer_open.start_date) }
    it { should have_content(@job_offer_running.start_date) }

    it { should have_content(@job_offer_open.employer.name) }
    it { should have_content(@job_offer_running.employer.name) }

  end

 end
