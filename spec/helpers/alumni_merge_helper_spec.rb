require 'spec_helper'
require 'csv'

describe AlumniMergeHelper do
  describe "generate_alumni_email_from_emails" do
    it "calculates nothing if alumni mail is already available" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_mail,weitere_emailadresse\nA,B,student@hpi-alumni.de,private_mail@shpi.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'student@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from the private email" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_mail,weitere_emailadresse\nA,B,,private_mail@student.hpi.uni-potsdam.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'private_mail@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from a additional email" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_mail,weitere_emailadresse\nA,B,,private_mail@shpi.de,additional_mail@student.hpi.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'additional_mail@hpi-alumni.de'
      end
    end

    it "generates alumni mail from row correctly" do
      raw_data = ['B v. C,A,,,', 'B,A B,,,', 'B-C,A,,,']
      expected = ['GENERATED_a.b@hpi-alumni.de', 'GENERATED_a.b@hpi-alumni.de', 'GENERATED_a.b-c@hpi-alumni.de' ]

      raw_data.each_with_index do |raw_item, index|
        alumni_row = CSV("nachname,vorname,alumnimail,private_mail\n" + raw_item, :headers => true, header_converters: :symbol)
        alumni_row.each do |row|
          expect(AlumniMergeHelper.generate_alumni_email_from_name(row)).to eq expected[index]
        end
      end
    end
  end

  describe "clean_alumni_row" do
    it "adds the first and last name from the alumni mail" do
      alumni_row = CSV("vorname,nachname,alumnimail\n,,max.meyer@hpi-alumni.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        cleaned_row = AlumniMergeHelper.clean_alumni_row(row)
        expect(cleaned_row[:vorname]).to eq 'Max'
        expect(cleaned_row[:nachname]).to eq 'Meyer'
        expect(cleaned_row[:alumnimail]).to eq 'max.meyer'
      end
    end

    it "adds the first and last name from the alumni mail" do
      alumni_row = CSV("vorname,nachname,alumnimail\n,,max.meyer@hpi-alumni.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        cleaned_row = AlumniMergeHelper.clean_alumni_row(row)
        expect(cleaned_row[:vorname]).to eq 'Max'
        expect(cleaned_row[:nachname]).to eq 'Meyer'
        expect(cleaned_row[:alumnimail]).to eq 'max.meyer'
      end
    end
  end

  describe "alumni merging" do
    before :each do
      alumni_merge_file = File.read(File.join fixture_path, "csv/alumni_to_merge_file.csv")
      @csv = CSV.parse(alumni_merge_file, headers: true, header_converters: :symbol, quote_char: '"')
    end

    it "merged the existing alumni with the given one" do
      existing_alumni = FactoryGirl.create(:alumni)
      alumni_row = CSV("vorname,nachname,alumnimail,email\nfirst,last,#{existing_alumni.alumni_email},myemail@host.com", :headers => true, header_converters: :symbol)
      alumni_row.each do |row|
        generated_alumni = AlumniMergeHelper.merge_from_row row
        expect(generated_alumni.firstname).to eq existing_alumni.firstname
        expect(generated_alumni.lastname).to eq existing_alumni.lastname
        expect(generated_alumni.alumni_email).to eq existing_alumni.alumni_email
        expect(generated_alumni.email).to eq existing_alumni.email
      end
    end

    it "creates a new alumni if there isn't one yet" do
      new_alumni = []
      @csv.each do |row|
        generated_alumni = AlumniMergeHelper.merge_from_row row
        new_alumni.push(generated_alumni)
      end
      #expect(new_alumni[0].firstname).to eq "Max"
      #expect(new_alumni[0].lastname).to eq "Müller"
      #expect(new_alumni[0].alumnimail).to eq "max.mueller@hpi-alumni.de"
      expect(new_alumni[0].hidden_title).to eq "Dr."
      expect(new_alumni[0].hidden_birth_name).to eq nil
      expect(new_alumni[0].hidden_graduation_id).to eq 3
      expect(new_alumni[0].hidden_graduation_year).to eq 2014 
      expect(new_alumni[0].hidden_private_email).to eq "max@müller.de"
      expect(new_alumni[0].hidden_alumni_email).to eq "max.mueller@hpi-alumni.de"
      expect(new_alumni[0].hidden_additional_email).to eq "max.mueller@gmail.com"
      expect(new_alumni[0].hidden_last_employer).to eq "SAP"
      expect(new_alumni[0].hidden_current_position).to eq "Developer"
      expect(new_alumni[0].hidden_street).to eq "Waldstraße 1"
      expect(new_alumni[0].hidden_location).to eq "Berlin"
      expect(new_alumni[0].hidden_postcode).to eq "10110"
      expect(new_alumni[0].hidden_country).to eq "Deutschland"
      expect(new_alumni[0].hidden_phone_number).to eq "815"
      expect(new_alumni[0].hidden_comment).to eq "guter Student"
      expect(new_alumni[0].hidden_agreed_alumni_work).to eq "Ja, nur über Email"
    end
  end
end