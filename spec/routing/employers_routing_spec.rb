# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#

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
      get("/employers/1").should route_to("employers#show", id: "1")
    end

    it "routes to #edit" do
      get("/employers/1/edit").should route_to("employers#edit", id: "1")
    end

    it "routes to #create" do
      post("/employers").should route_to("employers#create")
    end

    it "routes to #update" do
      put("/employers/1").should route_to("employers#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/employers/1").should route_to("employers#destroy", id: "1")
    end

  end
end
