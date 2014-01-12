require 'spec_helper'

describe "Staff" do
  describe "GET /staff" do
  	let(:staff_role) { FactoryGirl.create(:role, name: 'Staff', level: 2) }
 	let(:staff) { FactoryGirl.create(:user, role: staff_role) }

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login_as(staff, :scope => :user)
      get staff_index_path
      response.status.should be(200)
    end
  end
end
