# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  employer_id  :integer
#  job_offer_id :integer
#  score        :integer
#  headline     :text
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Rating do
  
  before(:each) do
    @rating = FactoryGirl.create(:rating)
  end
 
  context "validations" do 
    
    it "is invalid with too high score values" do
      @rating.score = 100
      expect(@rating).to_not be_valid
    end
    
    it "is invalid with negative score values" do
      @rating.score = -10
      expect(@rating).to_not be_valid
    end
    
    it "is invalid with a zero score value" do
      @rating.score = 0
      expect(@rating).to_not be_valid
    end
    
    it "is invalid if headline is not present" do
      @rating.headline = ''
      expect(@rating).to_not be_valid
    end
    
    it "is invalid if description not present" do
      @rating.description = ''
      expect(@rating).to_not be_valid
    end
  end
end

