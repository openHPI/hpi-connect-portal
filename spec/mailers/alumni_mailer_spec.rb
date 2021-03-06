require "rails_helper"

describe AlumniMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe "deliver_reminder" do

    it "delivers mail" do
      alumni = FactoryBot.create(:alumni)
      AlumniMailer.reminder_email(alumni).deliver_now
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
