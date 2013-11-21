require "spec_helper"

describe ProgrammingLanguagesController do
  describe "routing" do

    it "routes to #index" do
      get("/programming_languages").should route_to("programming_languages#index")
    end

    it "routes to #new" do
      get("/programming_languages/new").should route_to("programming_languages#new")
    end

    it "routes to #show" do
      get("/programming_languages/1").should route_to("programming_languages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/programming_languages/1/edit").should route_to("programming_languages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/programming_languages").should route_to("programming_languages#create")
    end

    it "routes to #update" do
      put("/programming_languages/1").should route_to("programming_languages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/programming_languages/1").should route_to("programming_languages#destroy", :id => "1")
    end

  end
end
