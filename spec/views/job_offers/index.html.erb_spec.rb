require 'spec_helper'

describe "job_offers/index" do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
    assign(:employers, [@employer])
    job_offers = [stub_model(JobOffer,
        :employer => @employer,
        :title => "Title",
        :start_date => '2013-11-10'
      ),
      stub_model(JobOffer,
        :employer => @employer,
        :title => "Title",
        :start_date => '2013-11-11'
      )]
    assign(:job_offers_list, {:items => job_offers,
                        :name => "job_offers.archive"})
    assign(:radio_button_sort_value, {"date" => false, "employer" => false})

    view.stub(:signed_in?) { false }
    view.stub(:current_user) { FactoryGirl.create(:user) }
    view.stub(:can?) { true }
  end

  it "renders a list of job_offers" do
    view.stub(:will_paginate)

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", :text => "Title".to_s, :count => 2
    assert_select ".employer", :text => @employer.name.to_s, :count => 2
  end

  it "has a date radio_button that is checked when loaded" do
    view.stub(:will_paginate)
    render
    assert_select "input[id='sort_by_date_RB'][checked='checked']"
  end
end
