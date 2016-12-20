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

require 'spec_helper'

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
end
