require 'spec_helper'

describe "job_offers/index" do
  before(:each) do
    assign(:job_offers, [
      stub_model(JobOffer,
        :chair => "Chair",
        :title => "Title"
      ),
      stub_model(JobOffer,
        :chair => "Chair",
        :title => "Title"
      )
    ])
    assign(:radio_button_sort_value, {"date" => false, "chair" => false})
  end

  it "renders a list of job_offers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", :text => "Title".to_s, :count => 2
    assert_select ".chair", :text => "Chair".to_s, :count => 2
  end
end
