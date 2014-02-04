require 'spec_helper'

describe "job_offers/edit" do
  before(:each) do
    @job_offer = assign(:job_offer, stub_model(JobOffer,
      :description => "MyString",
      :title => "MyString"
    ))
  end
end
