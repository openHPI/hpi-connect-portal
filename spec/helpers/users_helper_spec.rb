require 'spec_helper'

describe UsersHelper do
  before(:each) do
    helper.stub(:signed_in?) { true }
  end

  it "check if user is staff of employer" do
    job_offer = FactoryGirl.create(:job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:staff, employer: job_offer.employer).user }
    assert helper.user_is_staff_of_employer?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:student).user }
    assert !helper.user_is_staff_of_employer?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:staff, employer: FactoryGirl.create(:employer)).user }
    assert !helper.user_is_staff_of_employer?(job_offer)
  end

  it "checks if the user is the responsible user" do
    job_offer = FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:staff))

    helper.stub(:current_user) { job_offer.responsible_user.user }
    assert helper.user_is_responsible_user?(job_offer)

    helper.stub(:current_user) { FactoryGirl.create(:staff).user }
    assert !helper.user_is_responsible_user?(job_offer)
  end

  it "checks user is deputy of employer" do
    employer = FactoryGirl.create(:employer)

    helper.stub(:current_user) { employer.deputy.user }
    assert helper.user_is_deputy_of_employer?(employer)

    helper.stub(:current_user) { FactoryGirl.create(:employer).deputy.user }
    assert !helper.user_is_deputy_of_employer?(employer)
  end

  it "checks if the user can demote staff" do
    helper.stub(:current_user) { FactoryGirl.create(:user, :admin) }
    assert helper.user_can_demote_staff?

    helper.stub(:current_user) { FactoryGirl.create(:employer).deputy.user }
    assert helper.user_can_demote_staff?

    helper.stub(:current_user) { FactoryGirl.create(:student).user }
    assert !helper.user_can_demote_staff?

    helper.stub(:current_user) { FactoryGirl.create(:job_offer).responsible_user.user }
    assert !helper.user_can_demote_staff?
  end

  it "checks if user is deputy at all" do
    helper.stub(:current_user) { FactoryGirl.create(:employer).deputy.user }
    assert helper.user_is_deputy?

    helper.stub(:current_user) { FactoryGirl.create(:student).user }
    assert !helper.user_is_deputy?

    helper.stub(:current_user) { FactoryGirl.create(:job_offer).responsible_user.user }
    assert !helper.user_is_deputy?
  end
end
