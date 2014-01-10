require 'spec_helper'

describe "ResearchAssistants" do
  describe "GET /research_assistants" do
  	let(:research_assistant_role) { FactoryGirl.create(:role, name: 'Research Assistant', level: 2) }
 	let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role) }

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login_as(research_assistant, :scope => :user)
      get research_assistants_path
      response.status.should be(200)
    end
  end
end
