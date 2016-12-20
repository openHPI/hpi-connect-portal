require 'rails_helper'

describe "job_offers/index" do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
    assign(:employers, [@employer])
    
    @job_offer_1 = FactoryGirl.create(:job_offer, employer: @employer)
    @job_offer_2 = FactoryGirl.create(:job_offer, employer: @employer)
    job_offers = [@job_offer_1, @job_offer_2]
    
    assign(:job_offers_list, {items: job_offers,
                        name: "job_offers.archive"})
    assign(:radio_button_sort_value, {"date" => false, "employer" => false})

    allow(view).to receive(:signed_in?) { false }
    allow(view).to receive(:current_user) { FactoryGirl.create(:user) }
    allow(view).to receive(:can?) { true }
  end

  it "renders a list of job_offers" do
    allow(view).to receive(:will_paginate)

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", text: @job_offer_1.title, count: 1
    assert_select "h4", text: @job_offer_2.title, count: 1
    assert_select ".employer", text: @employer.name, count: 2
  end

  it "has a date radio_button that is checked when loaded" do
    allow(view).to receive(:will_paginate)
    render
    assert_select "input[id='sort_by_date_RB'][checked='checked']"
  end
end
