require 'spec_helper'

describe "job_offers/new" do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
    assign(:job_offer, stub_model(JobOffer,
      :description => "MyString",
      :title => "MyString",
      :employer => @employer,
      :start_date => Date.new(2013, 10, 1),
      :end_date => Date.new(2014, 03, 31),
      :time_effort => 7,
      :compensation => 10,
    ).as_new_record)

  end

  it "renders new job_offer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", job_offers_path, "post" do
      assert_select "input#job_offer_description[name=?]", "job_offer[description]"
      assert_select "input#job_offer_title[name=?]", "job_offer[title]"
    end
  end
end
