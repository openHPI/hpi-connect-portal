require 'spec_helper'

describe "the students listing" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ApplicationHelper

  subject { page }

  let(:employer) { FactoryGirl.create(:employer) }
  let(:staff)    { FactoryGirl.create(:user, role: FactoryGirl.create(:role, :staff), employer: employer) }
  let(:deputy)   { employer.deputy }

  before(:each) do
    @student1 = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student))
    ActionMailer::Base.deliveries = []
  end

  it "should have promote button for deputies" do
    # staff creates a new job offer for his employer
    login_as(deputy, :scope => :user)

    visit students_path
    expect(page).to have_content(@student1.firstname, @student1.lastname)

    page.should have_button("Promote")
  end
end