require "spec_helper"

describe ApplicationsController do
  describe "routing" do

    it "routes to #create" do
      post("/applications").should route_to("applications#create")
    end

  end
end
