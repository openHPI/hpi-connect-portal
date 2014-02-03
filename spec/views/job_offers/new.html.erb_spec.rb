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
end
