require 'spec_helper'

describe "ResearchAssistants" do
  describe "GET /research_assistants" do

  	before :all do
	  	FactoryGirl.create(:role,
            :name => "Admin")
        @admin = FactoryGirl.create(:user,
            :role => Role.where(name: "Admin").first
        )
    end

  	before :each do
        login_as(@admin, :scope => :user)
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get research_assistants_path
      response.status.should be(200)
    end
  end
end
