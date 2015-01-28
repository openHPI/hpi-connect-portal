require "spec_helper"

describe AlumniMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe "deliver_reminder" do

    it "delivers mail" do
      alumni = FactoryGirl.create(:alumni)
      assert_equal 0, Sidekiq::Extensions::DelayedMailer.jobs.size
      AlumniMailer.delay.reminder_email(alumni.id)
      assert_equal 1, Sidekiq::Extensions::DelayedMailer.jobs.size
    end
  end
end