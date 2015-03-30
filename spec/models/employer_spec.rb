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
  end
  
  describe "#average_rating" do 
    context "employer rated" do
      it "returns the arithmetic mean of all rating scores" do
        r1 = FactoryGirl.create(:rating, score_overall: 3, employer: @employer)
        r2 = FactoryGirl.create(:rating, score_overall: 4, employer: @employer)
          
        expect(@employer.average_rating).to be_within(0.05).of(((3+4)/2.0))
      end
    end
    
    context "employer not yet rated" do 
      it "returns nil" do
        expect(@employer.average_rating).to be_nil
      end
    end
  end
  
end
