# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#  visibility_id          :integer          default(0), not null
#  dschool_status_id      :integer          default(0), not null
#  group_id               :integer          default(0), not null
#

require "spec_helper"

describe StudentsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/students")).to route_to("students#index")
    end

    it "routes to #new" do
      expect(get("/students/new")).to route_to("students#new")
    end

    it "routes to #show" do
      expect(get("/students/1")).to route_to("students#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/students/1/edit")).to route_to("students#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("/students")).to route_to("students#create")
    end

    it "routes to #update" do
      expect(put("/students/1")).to route_to("students#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/students/1")).to route_to("students#destroy", id: "1")
    end

  end
end
