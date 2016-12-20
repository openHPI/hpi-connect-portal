require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the JobOffersHelper. For example:
#
# describe JobOffersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe JobOffersHelper do
  describe "start date" do
    it "is from now on/ ab sofort if flexible" do
      @job_offer = FactoryGirl.create(:job_offer, flexible_start_date: true)
      assert_equal(human_readable_start_date, t('job_offers.default_start_date'))
    end

    it "is is the actual date if not flexible" do
      @job_offer = FactoryGirl.create(:job_offer, flexible_start_date: false)
      assert_equal(human_readable_start_date, @job_offer.start_date.to_s)
    end
  end
end
