require "spec_helper"

describe StudentsController do
  describe "routing" do

    it "routes to #index" do
      get("/students").should route_to("students#index")
    end

    it "routes to #new" do
      get("/students/new").should route_to("students#new")
    end

    it "routes to #show" do
      get("/students/1").should route_to("students#show", :id => "1")
    end

    it "routes to #edit" do
      get("/students/1/edit").should route_to("students#edit", :id => "1")
    end

    it "routes to #create" do
      post("/students").should route_to("students#create")
    end

    it "routes to #update" do
      put("/students/1").should route_to("students#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/students/1").should route_to("students#destroy", :id => "1")
    end

  end
end
