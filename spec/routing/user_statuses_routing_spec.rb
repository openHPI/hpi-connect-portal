require "spec_helper"

describe UserStatusesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_statuses").should route_to("user_statuses#index")
    end

    it "routes to #new" do
      get("/user_statuses/new").should route_to("user_statuses#new")
    end

    it "routes to #show" do
      get("/user_statuses/1").should route_to("user_statuses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_statuses/1/edit").should route_to("user_statuses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_statuses").should route_to("user_statuses#create")
    end

    it "routes to #update" do
      put("/user_statuses/1").should route_to("user_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_statuses/1").should route_to("user_statuses#destroy", :id => "1")
    end

  end
end
