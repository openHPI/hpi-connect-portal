require 'spec_helper'

describe "job_offers/show" do
  before(:each) do
    @TestChair = FactoryGirl.create(:chair, name:"TestChair")
    @job_offer = assign(:job_offer, stub_model(JobOffer,
      :description => "Description",
      :title => "Title",
      :chair => @TestChair
    ))
    view.stub(:signed_in?) { false }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/Title/)
  end

  it "renders no applications if not signed in" do
    render
    rendered.should_not match(/Applications/)
    rendered.should_not match(/Apply/)
  end
end
