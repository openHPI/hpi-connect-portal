require "spec_helper"

describe LanguagesController do
  describe "routing" do

    it "routes to #index" do
      get("/languages").should route_to("languages#index")
    end

    it "routes to #new" do
      get("/languages/new").should route_to("languages#new")
    end

    it "routes to #show" do
      get("/languages/1").should route_to("languages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/languages/1/edit").should route_to("languages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/languages").should route_to("languages#create")
    end

    it "routes to #update" do
      put("/languages/1").should route_to("languages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/languages/1").should route_to("languages#destroy", :id => "1")
    end

  end
end
