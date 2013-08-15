require "spec_helper"

describe JobOffersController do
  describe "routing" do

    it "routes to #index" do
      get("/job_offers").should route_to("job_offers#index")
    end

    it "routes to #new" do
      get("/job_offers/new").should route_to("job_offers#new")
    end

    it "routes to #show" do
      get("/job_offers/1").should route_to("job_offers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/job_offers/1/edit").should route_to("job_offers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/job_offers").should route_to("job_offers#create")
    end

    it "routes to #update" do
      put("/job_offers/1").should route_to("job_offers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/job_offers/1").should route_to("job_offers#destroy", :id => "1")
    end

  end
end
