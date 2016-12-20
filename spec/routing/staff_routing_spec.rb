require "spec_helper"

describe StaffController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/staff")).to route_to("staff#index")
    end

    # it "routes to #new" do
    #   get("/staff/new").should route_to("staff#new")
    # end

    it "routes to #show" do
      expect(get("/staff/1")).to route_to("staff#show", id: "1")
    end

    # it "routes to #create" do
    #   post("/staff").should route_to("staff#create")
    # end

    it "routes to #destroy" do
      expect(delete("/staff/1")).to route_to("staff#destroy", id: "1")
    end
  end
end
