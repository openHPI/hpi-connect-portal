require 'spec_helper'

describe "job_offers/show" do
  before(:each) do
    @TestChair = FactoryGirl.create(:chair, name:"TestChair")
    @job_offer = assign(:job_offer, stub_model(JobOffer,
      :description => "Description",
      :title => "Title",
      :chair => @TestChair,
      :responsible_user => FactoryGirl.create(:user),
      :status => FactoryGirl.create(:job_status, :name => "open")
    ))
    view.stub(:signed_in?) { false }
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Description/)
    rendered.should match(/Title/)
  end

  it "renders no applications if not signed in" do
    render
    rendered.should_not match(/Applications/)
    rendered.should_not match(/Apply/)
  end

  it "renders contact mailto link" do
    render

    rendered.should match(/Contact/)
    assert_select "a[href='mailto:" + @job_offer.responsible_user.email + "']"
  end
end
