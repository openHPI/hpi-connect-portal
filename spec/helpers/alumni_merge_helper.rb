require 'spec_helper'
require 'csv'

describe AlumniMergeHelper do
  describe "alumni mail retrieval" do
    it "calculates nothing if alumni mail is already available" do
      alumni_row = CSV("alumnimail,private_mail,weitere_emailadresse\nstudent@hpi-alumni.de,private_mail@shpi.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(generate_alumni_mail_from_emails(row)[:alumnimail]).to eq 'student@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from the private email" do
      alumni_row = CSV("alumnimail,private_mail,weitere_emailadresse\n,private_mail@student.hpi.uni-potsdam.de,2@mail.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(generate_alumni_mail_from_emails(row)[:alumnimail]).to eq 'private_mail@hpi-alumni.de'
      end
    end

    it "calculates the alumnimail correctly from a additional email" do
      alumni_row = CSV("alumnimail,private_mail,weitere_emailadresse\n,private_mail@shpi.de,additional_mail@student.hpi.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row| 
        expect(generate_alumni_mail_from_emails(row)[:alumnimail]).to eq 'additional_mail@hpi-alumni.de'
      end
    end

    it "throws an error if multiple hpi user names are found" do
      alumni_row = CSV("alumnimail,private_mail,weitere_emailadresse\n,student@student.hpi.de,additional_mail@student.hpi.uni-potsdam.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row|
        expect{generate_alumni_mail_from_emails(row)}.to raise_error(/Found multiple hpi user names/)
      end
    end

    it "throws an error if no hpi user names are found" do
      alumni_row = CSV("alumnimail,private_mail,weitere_emailadresse\n,me@gmx.com,additional_mail@web.de; 3@mail.de", :headers => true, header_converters: :symbol)
      alumni_row.each do |row|
        expect{generate_alumni_mail_from_emails(row)}.to raise_error('Could not generate hpi user name from emails')
      end
    end
  end
end