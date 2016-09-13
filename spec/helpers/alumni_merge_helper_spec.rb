require 'spec_helper'
require 'csv'

describe AlumniMergeHelper do
  describe "generate_alumni_email_from_emails" do
    it "calculates nothing if alumni mail is already available" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_email,weitere_emailadresse\nA,B,student@hpi-alumni.de,private_email@shpi.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'student@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from the private email" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_email,weitere_emailadresse\nA,B,,private_email@student.hpi.uni-potsdam.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'private_email@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from a additional email" do
      alumni_row = CSV("nachname,vorname,alumnimail,private_email,weitere_emailadresse\nA,B,,private_email@shpi.de,additional_mail@student.hpi.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(AlumniMergeHelper.generate_alumni_email_from_emails(row)[:alumnimail]).to eq 'additional_mail@hpi-alumni.de'
      end
    end

    it "generates alumni mail from row correctly" do
      raw_data = ['B v. C,A,,,', 'B,A B,,,', 'B-C,A,,,']
      expected = ['GENERATED_a.b@hpi-alumni.de', 'GENERATED_a.b@hpi-alumni.de', 'GENERATED_a.b-c@hpi-alumni.de' ]

      raw_data.each_with_index do |raw_item, index|
        alumni_row = CSV("nachname,vorname,alumnimail,private_email\n" + raw_item, :headers => true, header_converters: :symbol)
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
        expect(cleaned_row[:alumnimail]).to eq 'max.meyer@hpi-alumni.de'
      end
    end

    it "adds the first and last name from the alumni mail" do
      alumni_row = CSV("vorname,nachname,alumnimail\n,,max.meyer@hpi-alumni.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        cleaned_row = AlumniMergeHelper.clean_alumni_row(row)
        expect(cleaned_row[:vorname]).to eq 'Max'
        expect(cleaned_row[:nachname]).to eq 'Meyer'
        expect(cleaned_row[:alumnimail]).to eq 'max.meyer@hpi-alumni.de'
      end
    end
  end

  describe "alumni merging from CSV file" do
    before :each do
      @header = 'Nachname,Vorname,akad. Titel,Geburtsname,Abschluss,Jahr,private E-Mail,Alumni-Mail,Weitere E-Mail-Adresse,E-Mail-Verteiler,keine E-Mail,letztes Unternehmen,aktuelle Position,"Ort, Land",auf LinkedIN,Unternehmen bekannt,Straße,Ort,PLZ,Land,Telefon,Notiz,Einverständnis Alumniarbeit erteilt,Straße (weitere Adresse),PLZ,Stadt,Land'
    end

    describe "with complete alumni" do
      before :each do
        csv_content = @header + "\n" + 'Müller,Max,Dr.,,Promotion,2014,max@müller.de,max.mueller@hpi-alumni.de,max.mueller@gmail.com,,,SAP,Developer,"Berlin,  Deutschland",ja,,Waldstraße 1,Berlin,10110,Deutschland,815,guter Student,"Ja, nur über Email",,,,'
        @csv = CSV(csv_content, headers: true, header_converters: :symbol, quote_char: '"')
      end

      it "merges the existing invited alumni with the given one" do
        existing_alumni = FactoryGirl.create(:alumni)
        existing_alumni.update!(alumni_email: 'max.mueller@hpi-alumni.de')
        @csv.each do |row|
          generated_alumni = AlumniMergeHelper.merge_from_row row
          expect(generated_alumni.firstname).to eq existing_alumni.firstname
          expect(generated_alumni.lastname).to eq existing_alumni.lastname
          expect(generated_alumni.alumni_email).to eq existing_alumni.alumni_email
          expect(generated_alumni.email).to eq existing_alumni.email
          expect(generated_alumni.hidden_title).to eq "Dr."
          expect(generated_alumni.hidden_birth_name).to eq nil
          expect(generated_alumni.hidden_graduation_id).to eq 3
          expect(generated_alumni.hidden_graduation_year).to eq 2014 
          expect(generated_alumni.hidden_private_email).to eq "max@müller.de"
          expect(generated_alumni.hidden_alumni_email).to eq "max.mueller@hpi-alumni.de"
          expect(generated_alumni.hidden_additional_email).to eq "max.mueller@gmail.com"
          expect(generated_alumni.hidden_last_employer).to eq "SAP"
          expect(generated_alumni.hidden_current_position).to eq "Developer"
          expect(generated_alumni.hidden_street).to eq "Waldstraße 1"
          expect(generated_alumni.hidden_location).to eq "Berlin"
          expect(generated_alumni.hidden_postcode).to eq "10110"
          expect(generated_alumni.hidden_country).to eq "Deutschland"
          expect(generated_alumni.hidden_phone_number).to eq "815"
          expect(generated_alumni.hidden_comment).to eq "guter Student"
          expect(generated_alumni.hidden_agreed_alumni_work).to eq "Ja, nur über Email"
        end
      end


      xit "merges the existing registered alumni with the given one" do
        existing_student = FactoryGirl.create(:student)
        existing_student.user.update!(alumni_email: 'max.mueller@hpi-alumni.de')
        @csv.each do |row|
          generated_alumni = AlumniMergeHelper.merge_from_row row
          expect(generated_alumni.user.firstname).to eq existing_student.user.firstname
          expect(generated_alumni.user.lastname).to eq existing_student.user.lastname
          expect(generated_alumni.user.alumni_email).to eq existing_student.user.alumni_email
          expect(generated_alumni.email).to eq existing_student.email
          expect(generated_alumni.hidden_title).to eq "Dr."
          expect(generated_alumni.hidden_birth_name).to eq nil
          expect(generated_alumni.hidden_graduation_id).to eq 3
          expect(generated_alumni.hidden_graduation_year).to eq 2014 
          expect(generated_alumni.hidden_private_email).to eq "max@müller.de"
          expect(generated_alumni.hidden_alumni_email).to eq "max.mueller@hpi-alumni.de"
          expect(generated_alumni.hidden_additional_email).to eq "max.mueller@gmail.com"
          expect(generated_alumni.hidden_last_employer).to eq "SAP"
          expect(generated_alumni.hidden_current_position).to eq "Developer"
          expect(generated_alumni.hidden_street).to eq "Waldstraße 1"
          expect(generated_alumni.hidden_location).to eq "Berlin"
          expect(generated_alumni.hidden_postcode).to eq "10110"
          expect(generated_alumni.hidden_country).to eq "Deutschland"
          expect(generated_alumni.hidden_phone_number).to eq "815"
          expect(generated_alumni.hidden_comment).to eq "guter Student"
          expect(generated_alumni.hidden_agreed_alumni_work).to eq "Ja, nur über Email"
        end
      end

      it "creates a new alumni if there isn't one yet" do
        @csv.each do |row|
          generated_alumni = AlumniMergeHelper.merge_from_row row
          #expect(generated_alumni.firstname).to eq "Max"
          #expect(generated_alumni.lastname).to eq "Müller"
          #expect(generated_alumni.alumnimail).to eq "max.mueller@hpi-alumni.de"
          expect(generated_alumni.hidden_title).to eq "Dr."
          expect(generated_alumni.hidden_birth_name).to eq nil
          expect(generated_alumni.hidden_graduation_id).to eq 3
          expect(generated_alumni.hidden_graduation_year).to eq 2014 
          expect(generated_alumni.hidden_private_email).to eq "max@müller.de"
          expect(generated_alumni.hidden_alumni_email).to eq "max.mueller@hpi-alumni.de"
          expect(generated_alumni.hidden_additional_email).to eq "max.mueller@gmail.com"
          expect(generated_alumni.hidden_last_employer).to eq "SAP"
          expect(generated_alumni.hidden_current_position).to eq "Developer"
          expect(generated_alumni.hidden_street).to eq "Waldstraße 1"
          expect(generated_alumni.hidden_location).to eq "Berlin"
          expect(generated_alumni.hidden_postcode).to eq "10110"
          expect(generated_alumni.hidden_country).to eq "Deutschland"
          expect(generated_alumni.hidden_phone_number).to eq "815"
          expect(generated_alumni.hidden_comment).to eq "guter Student"
          expect(generated_alumni.hidden_agreed_alumni_work).to eq "Ja, nur über Email"
        end
      end
    end
  end
end