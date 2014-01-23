require "spec_helper"

describe EmployersController do
  describe "routing" do

    it "routes to #index" do
      get("/employers").should route_to("employers#index")
    end

    it "routes to #new" do
      get("/employers/new").should route_to("employers#new")
    end

    it "routes to #show" do
      get("/employers/1").should route_to("employers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/employers/1/edit").should route_to("employers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/employers").should route_to("employers#create")
    end

    it "routes to #update" do
      put("/employers/1").should route_to("employers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/employers/1").should route_to("employers#destroy", :id => "1")
    end

  end
end
