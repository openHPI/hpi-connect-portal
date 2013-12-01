require 'spec_helper'

describe "job_offers/index" do
  before(:each) do
    @TestChair = FactoryGirl.create(:chair, name:"Chair")
    assign(:job_offers, [
      stub_model(JobOffer,
        :chair => @TestChair,
        :title => "Title",
        :start_date => '2013-11-10'
      ),
      stub_model(JobOffer,
        :chair => @TestChair,
        :title => "Title",
        :start_date => '2013-11-11'
      )
    ])
    assign(:radio_button_sort_value, {"date" => false, "chair" => false})
  end

  it "renders a list of job_offers" do
    view.stub(:will_paginate)
    render 
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", :text => "Title".to_s, :count => 2
    #assert_select "chair", :text => "Chair".to_s, :count => 2
  end

  it "has a date radio_button that is checked when loaded" do
    view.stub(:will_paginate)
    render 
    assert_select "input[id='sort_by_date_RB'][checked='checked']"
  end
end
