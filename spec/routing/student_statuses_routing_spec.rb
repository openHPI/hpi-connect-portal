require "spec_helper"

describe StudentStatusesController do
  describe "routing" do

    it "routes to #index" do
      get("/student_statuses").should route_to("student_statuses#index")
    end

    it "routes to #new" do
      get("/student_statuses/new").should route_to("student_statuses#new")
    end

    it "routes to #show" do
      get("/student_statuses/1").should route_to("student_statuses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/student_statuses/1/edit").should route_to("student_statuses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/student_statuses").should route_to("student_statuses#create")
    end

    it "routes to #update" do
      put("/student_statuses/1").should route_to("student_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/student_statuses/1").should route_to("student_statuses#destroy", :id => "1")
    end

  end
end
