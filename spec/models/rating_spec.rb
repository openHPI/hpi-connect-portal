# == Schema Information
#
# Table name: ratings
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  employer_id             :integer
#  job_offer_id            :integer
#  headline                :string(255)
#  description             :text
#  score_overall           :integer
#  score_atmosphere        :integer
#  score_salary            :integer
#  score_work_life_balance :integer
#  score_work_contents     :integer
#

require 'spec_helper'

describe Rating do
  
  before(:each) do
    @rating = FactoryGirl.create(:rating)
  end
 
  context "validations" do 
    
    context "overall score value" do 
      
      it "is invalid with too high score values" do
        @rating.score_overall = 100
        expect(@rating).to_not be_valid
      end
      
      it "is invalid with negative score values" do
        @rating.score_overall = -10
        expect(@rating).to_not be_valid
      end
      
      it "is invalid with a zero score value" do
        @rating.score_overall = 0
        expect(@rating).to_not be_valid
      end
      
      it "is invalid without a score value" do
        @rating.score_overall = nil
        expect(@rating).to_not be_valid
      end
    end
    
    context "athmosphere score value" do 
      
      it "is invalid with negative score values" do
        @rating.score_atmosphere = -10
        expect(@rating).to_not be_valid
      end
      
      it "is valid without a score value" do
        @rating.score_atmosphere = nil
        expect(@rating).to be_valid
      end  
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

