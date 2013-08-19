require 'spec_helper'

describe "job_offers/index" do
  before(:each) do
    assign(:job_offers, [
      stub_model(JobOffer,
        :description => "Description",
        :title => "Title"
      ),
      stub_model(JobOffer,
        :description => "Description",
        :title => "Title"
      )
    ])
  end

  it "renders a list of job_offers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
