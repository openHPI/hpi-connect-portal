require 'spec_helper'

describe UsersHelper do
  before(:each) do
    helper.stub(:signed_in?) { true }
  end

  it "check if user is staff of employer" do
    job_offer = FactoryGirl.create(:job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:user, :staff, employer: job_offer.employer) }
    assert helper.user_is_staff_of_employer?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:user, :student, employer: job_offer.employer) }
    assert !helper.user_is_staff_of_employer?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:user, :staff, employer: FactoryGirl.create(:employer)) }
    assert !helper.user_is_staff_of_employer?(job_offer)
  end

  it "checks if the user is the responsible user" do
    job_offer = FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user, :staff))

    helper.stub(:current_user) { job_offer.responsible_user }
    assert helper.user_is_responsible_user?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:user, :staff) }
    assert !helper.user_is_responsible_user?(job_offer)
  end
end
