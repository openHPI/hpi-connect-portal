# == Schema Information
#
# Table name: alumnis
#
#  id           :integer          not null, primary key
#  firstname    :string(255)
#  lastname     :string(255)
#  email        :string(255)      not null
#  alumni_email :string(255)      not null
#  token        :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Alumni do
  describe "validations" do
    before(:each) do
      @alumni = FactoryGirl.create :alumni
    end
    
    it "should not be valid with empty attributes" do
      assert !Alumni.new.valid?
    end

    it "should not be valid without email" do
      @alumni.email = nil
      @alumni.should be_invalid
    end

    it "should not be valid without alumni_email" do
      @alumni.alumni_email = nil
      @alumni.should be_invalid
    end

    it "should not be valid without token" do
      @alumni.token = nil
      @alumni.should be_invalid
    end

    it "should not be valid with an alumni email already registered on a user" do
      FactoryGirl.create :user, alumni_email: 'alumni@alumni.de'
      @alumni.alumni_email = 'alumni@alumni.de'
      @alumni.should be_invalid
    end
  end
end
