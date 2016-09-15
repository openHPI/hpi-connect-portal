# == Schema Information
#
# Table name: alumnis
#
#  id                        :integer          not null, primary key
#  firstname                 :string(255)
#  lastname                  :string(255)
#  email                     :string(255)      not null
#  alumni_email              :string(255)      not null
#  token                     :string(255)      not null
#  created_at                :datetime
#  updated_at                :datetime
#  hidden_title              :string(255)
#  hidden_birth_name         :string(255)
#  hidden_graduation_id      :integer
#  hidden_graduation_year    :integer
#  hidden_private_email      :string(255)
#  hidden_alumni_email       :string(255)
#  hidden_additional_email   :string(255)
#  hidden_last_employer      :string(255)
#  hidden_current_position   :string(255)
#  hidden_street             :string(255)
#  hidden_location           :string(255)
#  hidden_postcode           :string(255)
#  hidden_country            :string(255)
#  hidden_phone_number       :string(255)
#  hidden_comment            :string(255)
#  hidden_agreed_alumni_work :string(255)
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

  describe "send_reminder" do

    it "sends mail" do
      ActionMailer::Base.deliveries = []
      alumni = FactoryGirl.create :alumni
      alumni.send_reminder
      ActionMailer::Base.deliveries.count.should == 1
    end

  end
end
