require "spec_helper"

describe StaffController do
  describe "routing" do

    it "routes to #index" do
      get("/staff").should route_to("staff#index")
    end

    # it "routes to #new" do
    #   get("/staff/new").should route_to("staff#new")
    # end

    it "routes to #show" do
      get("/staff/1").should route_to("staff#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff/1/edit").should route_to("staff#edit", :id => "1")
    end

    # it "routes to #create" do
    #   post("/staff").should route_to("staff#create")
    # end

    it "routes to #update" do
      put("/staff/1").should route_to("staff#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff/1").should route_to("staff#destroy", :id => "1")
    end

  end
end
