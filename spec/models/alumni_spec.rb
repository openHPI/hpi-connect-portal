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

require 'rails_helper'

describe Alumni do
  describe "validations" do
    let(:alumnus) do
      FactoryGirl.create :alumni
    end

    it "should not be valid with empty attributes" do
      assert !Alumni.new.valid?
    end

    it "should not be valid without email" do
      alumnus.email = nil
      expect(alumnus).to be_invalid
    end

    it "should not be valid without alumni_email" do
      alumnus.alumni_email = nil
      expect(alumnus).to be_invalid
    end

    it "should not be valid without token" do
      alumnus.token = nil
      expect(alumnus).to be_invalid
    end

    it "should not be valid with an alumni email already registered on a user" do
      test_alumni_email = 'Firstname.Lastname'
      FactoryGirl.create(:user, alumni_email: test_alumni_email)
      alumnus.alumni_email = test_alumni_email
      expect(alumnus).to be_invalid
    end
  end

  describe "send_reminder" do

    it "sends mail" do
      ActionMailer::Base.deliveries = []
      alumni = FactoryGirl.create :alumni
      alumni.send_reminder
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

  end
end
