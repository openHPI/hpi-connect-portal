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

    it "creates token" do
      @employer.token.should_not be_nil
    end
  end

  describe "invite colleague" do

    before :each do
      ActionMailer::Base.deliveries =[]
      receiver_name = "Test Name"
      sender = FactoryGirl.create(:user)
      @employer.invite_colleague("test@mail.com", receiver_name, sender)
    end

    it "sends mail" do
      ActionMailer::Base.deliveries == 1
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

  describe "order by name" do
    it "orders by name case insensitive" do
      Employer.delete_all
      FactoryGirl.create(:employer, name: "Ca")
      FactoryGirl.create(:employer, name: "avis")
      FactoryGirl.create(:employer, name: "eBay")
      FactoryGirl.create(:employer, name: "Zuckerberg")
      FactoryGirl.create(:employer, name: "AtTheTop")
      ordered_employers = Employer.order_by_name
      ordered_employers[0].name.should == "AtTheTop"
      ordered_employers[1].name.should == "avis"
      ordered_employers[2].name.should == "Ca"
      ordered_employers[3].name.should == "eBay"
      ordered_employers[4].name.should == "Zuckerberg"
    end
  end
  
end
