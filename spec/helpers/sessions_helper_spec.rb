require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe SessionsHelper do

  before(:each) do
    @user = FactoryBot.create(:user)
    allow(helper).to receive(:current_user).and_return(@user)
  end

  it "returns correct results for current_user" do
    assert_equal(true, helper.current_user?(@user))
    assert_equal(false, helper.current_user?(FactoryBot.create(:user)))
  end

end
