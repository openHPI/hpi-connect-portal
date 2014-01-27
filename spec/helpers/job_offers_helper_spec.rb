require 'spec_helper'

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
  describe "get names of attributes of a job offer" do
  	it "gets all programming languages names that belong to job offer" do
  		@programming_language_1 = FactoryGirl.create(:programming_language)
    	@programming_language_2 = FactoryGirl.create(:programming_language)

      @job_offer = FactoryGirl.create(:job_offer, programming_languages: [@programming_language_1, @programming_language_2])
      result = get_programming_language_names
      assert_equal(result,[@programming_language_1.name,@programming_language_2.name])
  	end

  	it "gets all languages names that belong to job offer" do
    	@language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)

      @job_offer = FactoryGirl.create(:job_offer, languages: [@language_1, @language_2])
      result = get_language_names
      assert_equal(result,[t("languages."+@language_1.name), t("languages."+@language_2.name)])
  	end
  end

  describe "auto-value conversion" do
    it "returns the 'Haustarif' translation when the compensation is 10" do
      @job_offer = FactoryGirl.create(:job_offer, compensation: 10)
      assert_equal(human_readable_compensation, I18n.t('job_offers.default_compensation'))
    end

    it "returns the actual compensation if it is not 10" do
      @job_offer = FactoryGirl.create(:job_offer, compensation: 11)
      assert_equal(human_readable_compensation, @job_offer.compensation)
    end
  end
end
