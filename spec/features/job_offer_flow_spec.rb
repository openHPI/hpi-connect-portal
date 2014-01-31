require 'spec_helper'

describe "the job offer flow" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ApplicationHelper

	let(:employer) { FactoryGirl.create(:employer) }
	let(:creating_staff) { FactoryGirl.create(:user, role: FactoryGirl.create(:role, :staff), employer: employer) }
	let(:deputy) { employer.deputy }
  let(:first_applicant) { FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student)) }
  let(:second_applicant) { FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student)) }

	subject { page }

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)

    ActionMailer::Base.deliveries = []
  end

  it "behaves correctly" do
    # staff creates a new job offer for his employer
    login_as(creating_staff, :scope => :user)
		
    visit job_offers_path

	should have_link(I18n.t("job_offers.new_job_offer"))
	click_on I18n.t("job_offers.new_job_offer")
	current_path.should == new_job_offer_path

    fill_in "job_offer_title", :with => "HPI-Career-Portal"
    fill_in "job_offer_description", :with => "A new carrer portal for HPI students should be developed and deployed."
    fill_in "job_offer_room_number", :with => "A-1.2"
    fill_in "job_offer_end_date", :with => (Date.current + 2).to_s
    fill_in "job_offer_time_effort", :with => "12"
  
    JobOffer.delete_all
    expect {
      click_button I18n.t("links.save")
    }.to change(JobOffer, :count).by(1)

    job_offer = JobOffer.last
    current_path.should == job_offer_path(job_offer)
    assert job_offer.pending?

    assert_equal(job_offer.title, "HPI-Career-Portal")
    assert_equal(job_offer.description, "A new carrer portal for HPI students should be developed and deployed.")
    assert_equal(job_offer.room_number, "A-1.2")
    assert_equal(job_offer.start_date, Date.current + 1)
    assert_equal(job_offer.flexible_start_date, true)
    assert_equal(job_offer.end_date, Date.current + 2)
    assert_equal(job_offer.time_effort, 12)
    assert_equal(job_offer.compensation, 10.0)

    # deputy of the employers get acceptance pending email
    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [deputy.email])
    email.should have_selector("a[href='" + url_for(controller:"job_offers", action: "show", id: job_offer.id, only_path: false) + "']")
    ActionMailer::Base.deliveries = []

    # deputy accepts the new job offer
    login_as(deputy, :scope => :user)
    visit job_offer_path(job_offer)

    should have_link I18n.t("job_offers.accept"), accept_job_offer_path(job_offer)
    should have_link I18n.t("job_offers.decline"), decline_job_offer_path(job_offer)

    find_link(I18n.t("job_offers.accept")).click

    job_offer = job_offer.reload
    current_path.should == job_offer_path(job_offer)
    should_not have_selector(".alert alert-danger")
    assert job_offer.open?

    # responsible staff member gets notified that the job offer got accepted
    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [creating_staff.email])
    ActionMailer::Base.deliveries = []

    # student A applies for the job
    login_as(first_applicant, :scope => :user)
    visit job_offer_path(job_offer)

    click_button I18n.t("job_offers.apply")
    should have_selector("#applicationEmailModal", visible: true)

    file = File.join(fixture_path, "pdf/test_cv.pdf")
    message = "Hello Thomas, I'd really like to work on the new portal! All the best, Tim"
    fill_in "message", :with => message
    find("#attached_files").set(file)
    click_button I18n.t("job_offers.send_application")

    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [creating_staff.email])
    email.should have_content message
    email.attachments.should have(1).attachment
    attachment = email.attachments[0]
    attachment.should be_a_kind_of(Mail::Part)
    attachment.content_type.should be_start_with('application/pdf;')
    attachment.filename.should == 'test_cv.pdf'
    ActionMailer::Base.deliveries = []

    assert Application.where(job_offer: job_offer).load.count == 1
    should_not have_button I18n.t("job_offers.apply")

    # student B applies for the job
    login_as(second_applicant, :scope => :user)
    visit job_offer_path(job_offer)

    click_button I18n.t("job_offers.apply")
    should have_selector("#applicationEmailModal", visible: true)

    file = File.join(fixture_path, "pdf/test_cv.pdf")
    message = "Hello Thomas, I'd really like to work on the new portal! All the best, Tim"
    fill_in "message", :with => message
    find("#attached_files").set(file)
    click_button I18n.t("job_offers.send_application")

    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [creating_staff.email])
    email.should have_content message
    email.attachments.should have(1).attachment
    attachment = email.attachments[0]
    attachment.should be_a_kind_of(Mail::Part)
    attachment.content_type.should be_start_with('application/pdf;')
    attachment.filename.should == 'test_cv.pdf'
    ActionMailer::Base.deliveries = []

    assert Application.where(job_offer: job_offer).load.count == 2
    should_not have_button I18n.t("job_offers.apply")

    # responsible user accepts first application
    login_as(creating_staff, :scope => :user)
    visit job_offer_path(job_offer)

    # he sees the entries for the applicants
    should have_content first_applicant.email
    should have_content second_applicant.email

    find("a[href='"+accept_application_path(Application.where(job_offer: job_offer, user: first_applicant).first)+"']").click

    job_offer = job_offer.reload
    assert job_offer.running?
    assert Application.where(job_offer: job_offer).load.count == 0
    assert_equal(job_offer.assigned_students, [first_applicant])

    # accepted student, declined students and the HPI administration get notified
    ActionMailer::Base.deliveries.count.should == 3
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [first_applicant.email])
    email = ActionMailer::Base.deliveries[1]
    assert_equal(email.to, ["hpi.hiwi.portal@gmail.com"])
    email = ActionMailer::Base.deliveries[2]
    assert_equal(email.to, [second_applicant.email])
    ActionMailer::Base.deliveries = []

    # responsible user prolongs the job offer
    fill_in "job_offer_end_date", :with => (Date.current + 3).to_s
    click_button I18n.t("job_offers.prolong")
 
    # the job offers end date is updated
    job_offer.reload
    current_path.should == job_offer_path(job_offer)
    assert_equal(job_offer.end_date, Date.current + 3)
    assert_equal(job_offer.running?, true)

    # the administration of the HPI gets notified of the change
    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, ["hpi.hiwi.portal@gmail.com"])
    ActionMailer::Base.deliveries = []

    # responsible user tries to edit the job offer
    visit edit_job_offer_path(job_offer)
    current_path.should == job_offer_path(job_offer)
    should_not have_link I18n.t("links.edit")

    # responsible user tries to delete the job offer
    should_not have_link I18n.t("links.destroy")

    # responsible user closes the job
    find_link(I18n.t("job_offers.job_completed")).click

    # the administration of the HPI gets notified
    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    ActionMailer::Base.deliveries = []
    
    job_offer = job_offer.reload
    assert job_offer.completed?

    # responsible user reopens the jobs
    visit job_offer_path(job_offer)
    find_link(I18n.t("job_offers.reopen_job")).click

    current_path.should == reopen_job_offer_path(job_offer)

    should have_content mark_if_required(job_offer, :title)
    should have_content job_offer.description
    should have_content mark_if_required(job_offer, :room_number)
    should have_content mark_if_required(job_offer, :time_effort)
    should have_content mark_if_required(job_offer, :compensation)

    click_button I18n.t("links.save")

    assert JobOffer.all.count == 2
    job_offer = JobOffer.last

    # the deputy gets notified about the new job
    ActionMailer::Base.deliveries.count.should == 1
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [deputy.email])
    email.should have_selector("a[href='" + url_for(controller:"job_offers", action: "show", id: job_offer.id, only_path: false) + "']")
    ActionMailer::Base.deliveries = []
  end
end