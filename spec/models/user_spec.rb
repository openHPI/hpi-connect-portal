# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

require 'rails_helper'

describe User do
  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:alumnus) do
    FactoryGirl.create(:user, :alumnus)
  end

  describe 'validation of attributes' do

    it 'should not be valid with firstname not present' do
      user.firstname = nil
      expect(user).to be_invalid
    end

    it 'should not be valid with lastname not present' do
      user.lastname = nil
      expect(user).to be_invalid
    end

    it 'should not be valid with email not present' do
      user.email = nil
      expect(user).to be_invalid
    end

    it 'should not be valid with duplicate email' do
      expect(FactoryGirl.build(:user, email: user.email)).to be_invalid
    end

    it 'should not be valid with duplicate HPI email' do
      FactoryGirl.create(:user, email: 'test@student.hpi.uni-potsdam.de')
      expect(FactoryGirl.build(:user, email: 'test@student.hpi.de')).to be_invalid
    end

    it 'should not be valid with duplicate alumni email' do
      expect(FactoryGirl.build(:user, alumni_email: alumnus.alumni_email)).to be_invalid
      expect(FactoryGirl.build(:user, alumni_email: alumnus.alumni_email.downcase)).to be_invalid
    end

    it 'should not be valid as alumnus with hpi email' do
      alumnus.email = "test@hpi.de"
      expect(alumnus).to be_invalid
      alumnus.email = "test@student.hpi.uni-potsdam.de"
      expect(alumnus).to be_invalid
      alumnus.email = "test@hpi-alumni.de"
      expect(alumnus).to be_invalid
      alumnus.email = "test@bla.de"
      expect(alumnus).to be_valid
    end
  end

  describe 'Alumni data update' do
    before(:each) do
      require 'csv'

      @user = FactoryGirl.create(:user, :alumnus)

      @csv_row = CSV.parse_line("nachname,vorname,akad_titel,geburtsname,abschluss,jahr,private_email,alumnimail,weitere_emailadresse,emailverteiler,keine_email,letztes_unternehmen,aktuelle_position,ort_land,auf_linkedin,unternehmen_bekannt,strae,ort,plz,land,telefon,weitere_email_nicht_fr_newsletter_nutzen,notiz,einverstndnis_alumniarbeit_erteilt,strae_weitere_adresse,plz,stadt,land\n#{@user.lastname},#{@user.firstname},,,Bachelor,2017,private@example.com,#{@user.alumni_email}@hpi-alumni.de,,#{@user.alumni_email}@hpi-alumni.de\;,,Unternehmen,Developer,Deutschland,,,,,,,,,,,,,,", {headers: true, return_headers: false, header_converters: :symbol})
    end

    it "updates row with the user's email address" do
      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:weitere_emailadresse]).to eq(@user.email)
      expect(updated_row[:emailverteiler]).to eq("#{@user.alumni_email}@hpi-alumni.de;#{@user.email};")
    end

    it "doesn't add the user's email address if it is already in the row" do
      @csv_row[:private_email] = @user.email

      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:private_email]).to eq(@user.email)
      expect(updated_row[:weitere_emailadresse]).to eq(nil)
      expect(updated_row[:emailverteiler]).to eq("#{@user.alumni_email}@hpi-alumni.de;")

      @csv_row[:private_email] = 'private@example.com'
      @csv_row[:weitere_emailadresse] = @user.email
      @csv_row[:emailverteiler].concat("#{@user.email};")

      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:private_email]).to eq('private@example.com')
      expect(updated_row[:weitere_emailadresse]).to eq(@user.email)
      expect(updated_row[:emailverteiler]).to eq("#{@user.alumni_email}@hpi-alumni.de;#{@user.email};")
    end

    it 'adds a missing private email address' do
      @csv_row[:private_email] = nil

      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:private_email]).to eq(@user.email)
    end

    it 'extracts a missing alumni mail address from other HPI email addresses' do
      @csv_row[:private_email] = "#{@user.alumni_email}@student.hpi.de"
      @csv_row[:alumnimail] = nil
      @csv_row[:emailverteiler] = "#{@user.alumni_email}@student.hpi.de;"

      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:alumnimail]).to eq("#{@user.alumni_email}@hpi-alumni.de")
    end

    it 'updates the current employer and position' do
      @user.manifestation.cv_jobs << FactoryGirl.create(:cv_job, position: 'CEO', employer: 'Google Inc', current: true)

      updated_row = User.update_alumni_data(@csv_row)

      expect(updated_row[:letztes_unternehmen]).to eq("Google Inc")
      expect(updated_row[:aktuelle_position]).to eq("CEO")
    end
  end
end
