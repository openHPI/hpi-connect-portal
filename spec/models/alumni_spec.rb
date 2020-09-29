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
    let(:alumnus) { FactoryBot.create :alumni }

    it "is not valid with empty attributes" do
      assert !Alumni.new.valid?
    end

    it "is not valid without email" do
      alumnus.email = nil
      expect(alumnus).to be_invalid
    end

    it "is not valid without alumni_email" do
      alumnus.alumni_email = nil
      expect(alumnus).to be_invalid
    end

    it "is not valid without token" do
      alumnus.token = nil
      expect(alumnus).to be_invalid
    end

    it "is not valid with an alumni email already registered on a user" do
      test_alumni_email = 'Firstname.Lastname'
      FactoryBot.create(:user, alumni_email: test_alumni_email)
      alumnus.alumni_email = test_alumni_email
      expect(alumnus).to be_invalid
    end
  end

  describe "#send_reminder" do
    it "sends reminder mail" do
      ActionMailer::Base.deliveries = []
      alumni = FactoryBot.create :alumni
      alumni.send_reminder
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe ".create_from_row" do
    before :all do
      require 'csv'

      csv_headers = "firstname,lastname,email,alumni_email\n"
      @valid_csv_string = csv_headers + "Max,Mustermann,max@mustermann.de,Max.Mustermann2"
      @csv_string_without_fullname = csv_headers + ",,max@mustermann.de,Max.Mustermann2"
      @csv_string_mail_only = csv_headers + ",,max@mustermann.de,"
      @csv_options = { headers: true, return_headers: false, header_converters: :symbol }
    end

    context "when all fields are present" do
      before :all do
        @csv_row = CSV.parse_line(@valid_csv_string, @csv_options)
        @return_val = Alumni.create_from_row(@csv_row)
        @alumnus = Alumni.last
      end

      it "creates alumnus" do
        expect(@return_val).to eq(:created)
      end

      it "sends creation mail" do
        ActionMailer::Base.deliveries = []
        @return_val = Alumni.create_from_row(@csv_row)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it "uses the given first name" do
        expect(@alumnus.firstname).to eq(@csv_row[:firstname])
      end

      it "uses the given last name" do
        expect(@alumnus.lastname).to eq(@csv_row[:lastname])
      end

      it "uses the given email adress" do
        expect(@alumnus.email).to eq(@csv_row[:email])
      end

      it "uses the given alumni mail adress" do
        expect(@alumnus.alumni_email).to eq(@csv_row[:alumni_email])
      end
    end

    context "when full name isn't present, but alumni mail adress is" do
      before :all do
        @csv_row = CSV.parse_line(@csv_string_without_fullname, @csv_options)
        @return_val = Alumni.create_from_row(@csv_row)
        @alumnus = Alumni.last
      end

      it "creates alumnus" do
        expect(@return_val).to eq(:created)
      end

      it "uses the first name given by alumni mail adress" do
        expect(@alumnus.firstname).to eq(@csv_row[:alumni_email].split('.').first)
      end

      it "uses the last name given by alumni mail adress" do
        expect(@alumnus.lastname).to eq(@csv_row[:alumni_email].split('.').last)
      end
    end

    context "when alumni mail and full name aren't present" do
      before :all do
        @csv_row = CSV.parse_line(@csv_string_mail_only, @csv_options)
        @return_val = Alumni.create_from_row(@csv_row)
      end

      it "doesn't create alumnus" do
        expect(@return_val).not_to eq(:created)
      end
    end

    context "when mailer raises exception" do
      before :each do
        @csv_row = CSV.parse_line(@valid_csv_string, @csv_options)
        allow(AlumniMailer).to receive(:creation_email).and_raise(StandardError)
      end

      it "doesn't create alumnus" do
        expect {
          Alumni.create_from_row(@csv_row)
        }.not_to change(Alumni, :count)
      end
    end
  end

  describe ".export_unregistered_alumni" do
    before(:each) do
      require 'csv'

      @pending = FactoryBot.create(:alumni)
    end

    it "should export all unregistered alumni if options are set accordingly" do
      csv = CSV.parse(Alumni.export_unregistered_alumni)
      expect(csv.length).to eq 2
      expect(csv[0]).to eq(%w{lastname firstname alumni_email email invited_on})
      expect(csv[1]).to eq([@pending.lastname, @pending.firstname, @pending.alumni_email + "@hpi-alumni.de", @pending.email, @pending.created_at.strftime("%d.%m.%Y")])
    end
  end
end
