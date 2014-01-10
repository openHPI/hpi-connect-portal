require "spec_helper"

describe ResearchAssistantsController do
  describe "routing" do

    it "routes to #index" do
      get("/research_assistants").should route_to("research_assistants#index")
    end

    # it "routes to #new" do
    #   get("/research_assistants/new").should route_to("research_assistants#new")
    # end

    it "routes to #show" do
      get("/research_assistants/1").should route_to("research_assistants#show", :id => "1")
    end

    it "routes to #edit" do
      get("/research_assistants/1/edit").should route_to("research_assistants#edit", :id => "1")
    end

    # it "routes to #create" do
    #   post("/research_assistants").should route_to("research_assistants#create")
    # end

    it "routes to #update" do
      put("/research_assistants/1").should route_to("research_assistants#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/research_assistants/1").should route_to("research_assistants#destroy", :id => "1")
    end

  end
end
