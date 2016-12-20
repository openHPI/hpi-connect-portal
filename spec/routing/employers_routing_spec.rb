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

require "rails_helper"

describe EmployersController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/employers")).to route_to("employers#index")
    end

    it "routes to #new" do
      expect(get("/employers/new")).to route_to("employers#new")
    end

    it "routes to #show" do
      expect(get("/employers/1")).to route_to("employers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/employers/1/edit")).to route_to("employers#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("/employers")).to route_to("employers#create")
    end

    it "routes to #update" do
      expect(put("/employers/1")).to route_to("employers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/employers/1")).to route_to("employers#destroy", id: "1")
    end

  end
end
