require 'rails_helper'

describe "job_offers/edit" do
  before(:each) do
    @job_offer = assign(:job_offer, FactoryBot.create(:job_offer))
  end
end
