require 'spec_helper'

describe "the students listing" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ApplicationHelper

  subject { page }

  let(:employer) { FactoryGirl.create(:employer) }
  let(:deputy)   { employer.deputy }

  before(:each) do
    @student1 = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student))
    ActionMailer::Base.deliveries = []
  end

  it "should have promote button for deputies" do
    login_as(deputy, :scope => :user)

    visit students_path
    expect(page).to have_content(@student1.firstname, @student1.lastname)

    page.should have_button("Promote")
  end
end

describe "the chair page" do
  let(:employer) { FactoryGirl.create(:employer) }
  let(:deputy)   { employer.deputy }

  before(:each) do
    @staff1 = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :staff), employer: employer)
    @job_offer_open = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :open))
    @job_offer_running = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :running))
    @job_offer_pending = FactoryGirl.create(:job_offer, employer: employer, status: FactoryGirl.create(:job_status, :pending))
  end

  it "should have promote buttons next to staff for deputies" do
    login_as(deputy, :scope => :user)

    visit employer_path(employer)
    expect(page).to have_content(@staff1.firstname, @staff1.lastname)

    page.should have_button("Promote")
  end

  it "should have demote buttons next to staff for deputies" do
    login_as(deputy, :scope => :user)

    visit employer_path(employer)
    expect(page).to have_content(@staff1.firstname, @staff1.lastname)

    page.should have_button("Demote")
  end
end