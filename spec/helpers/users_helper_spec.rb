require 'spec_helper'

describe UsersHelper do
  before(:each) do
    allow(helper).to receive(:signed_in?) { true }
  end

  it "check if user is staff of employer" do
    job_offer = FactoryGirl.create(:job_offer)

    allow(helper).to receive(:current_user) { FactoryGirl.create(:staff, employer: job_offer.employer).user }
    assert helper.user_is_staff_of_employer?(job_offer)

    allow(helper).to receive(:current_user) { FactoryGirl.create(:student).user }
    assert !helper.user_is_staff_of_employer?(job_offer)

    allow(helper).to receive(:current_user) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)).user }
    assert !helper.user_is_staff_of_employer?(job_offer)
  end
end
