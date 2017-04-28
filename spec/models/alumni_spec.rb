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

  describe "create from row" do
    before(:all) do
      require 'csv'
    end

    it "creates alumnus when all fields are present" do
      csv_row = CSV.parse_line("firstname,lastname,email,alumni_email\nMax,Mustermann,max@mustermann.de,Max.Mustermann", {headers: true, return_headers: false, header_converters: :symbol})

      alumnus = Alumni.create_from_row(csv_row)

      expect(alumnus).to eq(:created)

      alumnus = Alumni.last

      expect(alumnus.firstname).to eq('Max')
      expect(alumnus.lastname).to eq('Mustermann')
      expect(alumnus.email).to eq('max@mustermann.de')
      expect(alumnus.alumni_email).to eq('Max.Mustermann')
    end

    it "creates alumnus when full name isn't present, but alumni mail adress is" do
      csv_row = CSV.parse_line("firstname,lastname,email,alumni_email\n,,max@mustermann.de,Max.Mustermann", {headers: true, return_headers: false, header_converters: :symbol})

      alumnus = Alumni.create_from_row(csv_row)

      expect(alumnus).to eq(:created)

      alumnus = Alumni.last

      expect(alumnus.firstname).to eq('Max')
      expect(alumnus.lastname).to eq('Mustermann')
      expect(alumnus.email).to eq('max@mustermann.de')
      expect(alumnus.alumni_email).to eq('Max.Mustermann')
    end

    it 'sends creation mail upon successful alumnus creation' do
      ActionMailer::Base.deliveries = []
      csv_row = CSV.parse_line("firstname,lastname,email,alumni_email\nMax,Mustermann,max@mustermann.de,Max.Mustermann", {headers: true, return_headers: false, header_converters: :symbol})

      alumnus = Alumni.create_from_row(csv_row)

      expect(alumnus).to eq(:created)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "doesn't create alumnus if alumni mail and full name aren't present" do
      csv_row = CSV.parse_line("firstname,lastname,email,alumni_email\n,,max@mustermann.de,", {headers: true, return_headers: false, header_converters: :symbol})

      alumnus = Alumni.create_from_row(csv_row)

      expect(alumnus).not_to eq(:created)
    end
  end
end
