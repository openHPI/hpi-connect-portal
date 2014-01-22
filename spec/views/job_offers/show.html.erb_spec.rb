require 'spec_helper'

describe "job_offers/show" do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
    @job_offer = assign(:job_offer, stub_model(JobOffer,
      :description => "Description",
      :title => "Title",
      :employer => @employer,
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

  it "hides the edit button if the job is running" do
    @job_offer.status = FactoryGirl.create(:job_status, :name => "running")
    @job_offer.save

    render

    rendered.should_not match(/Edit/)
  end
end
