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
  describe "get names of habtm attributes of a job offer" do
  	it "gets all programming languages names that belong to job offer" do
  		java = ProgrammingLanguage.new(:name => 'Java')
      	php = ProgrammingLanguage.new(:name => 'php')

      	@job_offer = FactoryGirl.create(:job_offer, programming_languages: [java, php])
      	result = get_programming_language_names
      	assert_equal(result,["Java","php"])
  	end

  	it "gets all languages names that belong to job offer" do
      	german = Language.new(:name => 'German')
      	english = Language.new(:name => 'English')

      	@job_offer = FactoryGirl.create(:job_offer, languages: [german, english])
      	result = get_language_names
      	assert_equal(result,["German","English"])
  	end
  end
end
