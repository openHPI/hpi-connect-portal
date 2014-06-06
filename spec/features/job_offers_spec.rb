require 'spec_helper'

describe "the job-offers page" do

  before(:each) do
    @active = JobStatus.active
    @student1 = FactoryGirl.create(:student)
    login @student1.user
    @epic = FactoryGirl.create(:employer, name:"EPIC", booked_package_id: 2)
    @test_employer = FactoryGirl.create(:employer)
    @staff = FactoryGirl.create(:staff)
    @job_offer_1 = FactoryGirl.create(:job_offer, title: "TestJob1", employer: @test_employer, status: @active)
    @job_offer_2 = FactoryGirl.create(:job_offer, title: "TestJob2", employer: @epic, status: @active)
    @job_offer_3 = FactoryGirl.create(:job_offer, title: "TestJob3", state_id: 3, category_id: JobOffer::CATEGORIES.index("graduate_job"), employer: @epic, status: @active)
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
      #{@job_offer_3.title}.*#{@job_offer_2.title}.*#{@job_offer_1.title}
    """.strip))
  end

  describe "student has already applied" do
    before(:each) do
      @student = FactoryGirl.create(:student)
      FactoryGirl.create(:application, student: @student, job_offer: @job_offer_1)
      login @student.user
    end

    it {
      visit job_offers_path
      page.should have_selector('span.label-success', count: 1, text: I18n.t('job_offers.already_applied_badge'))
    }
  end
end

describe "a job offer entry" do

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)

    @student1 = FactoryGirl.create(:student)
    login @student1.user

    @employer = FactoryGirl.create(:employer)
    @staff = FactoryGirl.create(:staff)
    @job_offer = FactoryGirl.create(:job_offer,
      title: "TestJob",
      employer: @employer,
      status: JobStatus.active
    )

    visit job_offers_path
  end

  it "should have a title and the professorship" do
    page.should have_content(@job_offer.title, @employer.name)
  end

  it "should link to its detailed page" do
    find_link("TestJob").click
    # we expect to be on the detailed page
    expect(current_path).to eq(job_offer_path(@job_offer))
  end
end

describe "job_offers_history" do

  before(:each) do
    @student1 = FactoryGirl.create(:student)
    login @student1.user
    @employer = FactoryGirl.create(:employer)
    @staff = FactoryGirl.create(:staff)
    @job_offer = FactoryGirl.create(:job_offer,
      title: "Closed Job Touch Floor",
      status: JobStatus.closed,
      employer: @employer,
      )
  end

  it "should have a job-offers-history" do
    visit job_offers_path
    find("div#buttons").should have_link "Archive"
    click_on "Archive"

    expect(current_path).to eq(archive_job_offers_path)

    page.should have_css "ul.list-group li"
    page.should have_css "#search"
    page.should have_css "#filter"
    page.should have_css "#search"
    find_button("Go").visible?
    first("ul.list-group li").should have_content "Closed Job Touch Floor"
  end
end
