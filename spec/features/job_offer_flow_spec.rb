require 'rails_helper'

describe "the job offer flow" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  include ApplicationHelper

  let(:employer) { FactoryBot.create(:employer) }
  let(:creating_staff) { FactoryBot.create(:staff, employer: employer) }
  let(:staff) { FactoryBot.create(:staff, employer: employer) }
  let(:admin) { FactoryBot.create(:user, :admin)}
  let(:first_applicant) { FactoryBot.create(:student) }
  let(:second_applicant) { FactoryBot.create(:student) }

  subject { page }

  before(:each) do
    employer.save
    ActionMailer::Base.deliveries = []
  end

  it "behaves correctly" do
    # staff creates a new job offer for his employer
    login creating_staff.user

    visit job_offers_path

    within "#top-links" do
        is_expected.to have_link(I18n.t("job_offers.new_job_offer"))
        click_on I18n.t("job_offers.new_job_offer")
    end
    expect(current_path).to eq(new_job_offer_path)

    fill_in "job_offer_title", with: "HPI-Career-Portal"
    fill_in "job_offer_description_en", with: "A new carrer portal for HPI students should be developed and deployed."
    fill_in "job_offer_end_date", with: (Date.current + 2).to_s
    fill_in "job_offer_time_effort", with: "12"
    fill_in "job_offer_compensation", with: "11"

    JobOffer.delete_all
    expect {
      click_button "submit"
    }.to change(JobOffer, :count).by(1)

    job_offer = JobOffer.last
    expect(current_path).to eq(job_offer_path(job_offer))
    assert job_offer.pending?

    assert_equal(job_offer.title, "HPI-Career-Portal")
    assert_equal(job_offer.description, "A new carrer portal for HPI students should be developed and deployed.")
    assert_equal(job_offer.start_date, Date.current + 1)
    assert_equal(job_offer.flexible_start_date, true)
    assert_equal(job_offer.end_date, Date.current + 2)
    assert_equal(job_offer.time_effort, 12)
    assert_equal(job_offer.compensation, 11.0)
    assert_equal(job_offer.employer, creating_staff.employer)
    assert_equal(job_offer.employer, staff.employer)
    assert_equal(employer.staff_members.length, 3)
    assert_equal(job_offer.contact.name, creating_staff.employer.contact.name)
    assert_equal(job_offer.contact.street, creating_staff.employer.contact.street)
    assert_equal(job_offer.contact.zip_city, creating_staff.employer.contact.zip_city)
    assert_equal(job_offer.contact.company, creating_staff.employer.name)

    # admin of the employers get acceptance pending email
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [Configurable.mailToAdministration])
    css = 'a[href=3D"' + url_for(controller:"job_offers", action: "show", id: job_offer.id, only_path: false) + '"]'
    expect(email).to have_selector('a')
    ActionMailer::Base.deliveries = []

    # admin accepts the new job offer
    login admin
    visit job_offer_path(job_offer)

    expect(current_path).to eq(job_offer_path(job_offer))

    is_expected.to have_link I18n.t("job_offers.accept"), href: accept_job_offer_path(job_offer)
    is_expected.to have_link I18n.t("job_offers.decline"), href: decline_job_offer_path(job_offer)

    find_link(I18n.t("job_offers.accept")).click

    job_offer = job_offer.reload
    expect(current_path).to eq(job_offer_path(job_offer))
    is_expected.not_to have_selector(".alert alert-danger")
    assert job_offer.active?

    # staff members get notified that the job offer got accepted
    expect(ActionMailer::Base.deliveries.count).to eq(employer.staff_members.length)
    emails = ActionMailer::Base.deliveries
    # each staff member gets notified
    employer.staff_members.each { |each_staff|
    assert_equal(emails.map { |mail| mail.to}.find(each_staff.email)!=nil, true)
    }
    ActionMailer::Base.deliveries = []

    # responsible user tries to edit the job offer
    visit edit_job_offer_path(job_offer)
    expect(current_path).not_to eq(job_offer_path(job_offer))
    is_expected.not_to have_link I18n.t("links.edit")

    # responsible user tries to delete the job offer
    is_expected.not_to have_link I18n.t("links.destroy")

    job_offer.update(status: JobStatus.closed)
    job_offer = job_offer.reload
    assert job_offer.closed?

    # employer of staff user reopens the jobs
    visit job_offer_path(job_offer)
    find_link(I18n.t("job_offers.reopen_job")).click

    expect(current_path).to eq(reopen_job_offer_path(job_offer))

    is_expected.to have_content mark_if_required(job_offer, :title)
    is_expected.to have_content job_offer.description
    is_expected.to have_content mark_if_required(job_offer, :time_effort)
    is_expected.to have_content mark_if_required(job_offer, :compensation)

    click_button "submit"

    assert_equal(JobOffer.all.count, 2)
    job_offer = JobOffer.last

    # the admins get notified about the new job
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    email = ActionMailer::Base.deliveries[0]
    assert_equal(email.to, [Configurable.mailToAdministration])
    expect(email).to have_selector("a")
    ActionMailer::Base.deliveries = []
  end
end
