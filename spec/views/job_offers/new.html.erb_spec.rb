require 'rails_helper'

describe "job_offers/new" do
  before(:each) do
    @employer = FactoryBot.create(:employer)
    assign(:job_offer, JobOffer.new(employer: @employer))
  end
end
