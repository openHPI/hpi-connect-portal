require 'spec_helper'

describe "job_offers/new" do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
    assign(:job_offer, JobOffer.new(employer: @employer))
  end
end
