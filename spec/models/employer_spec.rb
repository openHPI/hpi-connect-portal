# == Schema Information
#
# Table name: employers
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  deputy_id           :integer
#  activated           :boolean          default(FALSE), not null
#  place_of_business   :string(255)
#  website             :string(255)
#  line_of_business    :string(255)
#  year_of_foundation  :integer
#  number_of_employees :string(255)
#  requested_package   :integer          default(0), not null
#  booked_package      :integer          default(0), not null
#

require 'spec_helper'

describe Employer do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
  end

  describe "validation of parameters" do

    it "with name not present" do
      @employer.name = nil
      @employer.should be_invalid
    end

    it "with description not present" do
      @employer.description = nil
      @employer.should be_invalid
    end

    it "with deputy not present" do
      @employer.deputy = nil
      @employer.should be_invalid
    end

    it "with deputies employer is not the employer itself" do
      @employer.deputy.employer = nil
      @employer.should be_invalid
    end

    it "with name is not unique" do
      employer_with_same_name = @employer.dup
      assert employer_with_same_name.should be_invalid
    end

    it "with year_of_foundation less than 1800" do
      @employer.year_of_foundation = 1745
      @employer.should be_invalid
    end

    it "with year_of_foundation greater than 1800" do
      @employer.year_of_foundation = 1801
      @employer.should be_valid
    end

    it "with future year_of_foundation" do
      @employer.year_of_foundation = Time.now.year + 1
      @employer.should be_invalid
    end

    it "with number_of_employees not present" do
      @employer.number_of_employees = nil
      @employer.should be_invalid
    end

    it "with place_of_business not present" do
      @employer.place_of_business = nil
      @employer.should be_invalid
    end
  end
end
