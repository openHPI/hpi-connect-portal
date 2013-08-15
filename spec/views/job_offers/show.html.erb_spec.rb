require 'spec_helper'

describe "job_offers/show" do
  before(:each) do
    @job_offer = assign(:job_offer, stub_model(JobOffer,
      :title => "Title",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
