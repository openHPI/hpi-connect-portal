require 'spec_helper'


describe "the job-offers page" do

  before(:each) do
    @job_offer_1 = FactoryGirl.create(:joboffer, title: "TestJob1", chair: "TestChair")
    @job_offer_2 = FactoryGirl.create(:joboffer, title: "TestJob2")
    @job_offer_3 = FactoryGirl.create(:joboffer, title: "TestJob3")
  end

  it "should include all jobs currently available" do
    visit job_offers_path
    page.should have_content(
      @job_offer_1.title,
      @job_offer_2.title,
      @job_offer_3.title
    )
  end

  it "should sort the jobs by creation date" do
    visit job_offers_path
    # using regex for order of elements
    page.should have_content(Regexp.new("""
      #{@job_offer_1.title}.*#{@job_offer_2.title}.*#{@job_offer_3.title}
    """.strip))
  end
end


describe "a job offer entry" do

  before(:each) do
    @job_offer = FactoryGirl.create(:joboffer, title: "TestJob", chair: "TestChair")
  end

  it "should have a title and the professorship" do
    visit job_offers_path
    page.should have_content("TestJob", "TestChair")
  end

  it "should link to its detailed page" do
    visit job_offers_path
    find_link("TestJob").click
    # we expect to be on another page
    current_path.should_not == job_offers_path
  end
end
