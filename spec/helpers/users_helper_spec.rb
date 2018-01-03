require 'rails_helper'

describe UsersHelper do
  before(:each) do
    allow(helper).to receive(:signed_in?) { true }
  end

  it "check if user is staff of employer" do
    job_offer = FactoryBot.create(:job_offer)

    allow(helper).to receive(:current_user) { FactoryBot.create(:staff, employer: job_offer.employer).user }
    assert helper.user_is_staff_of_employer?(job_offer)

    allow(helper).to receive(:current_user) { FactoryBot.create(:student).user }
    assert !helper.user_is_staff_of_employer?(job_offer)

    allow(helper).to receive(:current_user) { FactoryBot.create(:staff, employer: FactoryBot.create(:employer)).user }
    assert !helper.user_is_staff_of_employer?(job_offer)
  end
end
