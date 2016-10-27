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
      user.should be_invalid
    end

    it 'should not be valid with lastname not present' do
      user.lastname = nil
      user.should be_invalid
    end

    it 'should not be valid with email not present' do
      user.email = nil
      user.should be_invalid
    end

    it 'should not be valid with duplicate email' do
      FactoryGirl.build(:user, email: user.email).should be_invalid
    end

    it 'should not be valid with duplicate HPI email' do
      FactoryGirl.create(:user, email: 'test@student.hpi.uni-potsdam.de')
      FactoryGirl.build(:user, email: 'test@student.hpi.de').should be_invalid
    end

    it 'should not be valid with duplicate alumni email' do
      FactoryGirl.build(:user, alumni_email: alumnus.alumni_email).should be_invalid
      FactoryGirl.build(:user, alumni_email: alumnus.alumni_email.downcase).should be_invalid
    end

    it 'should not be valid as alumnus with hpi email' do
      alumnus.email = "test@hpi.de"
      alumnus.should be_invalid
      alumnus.email = "test@student.hpi.uni-potsdam.de"
      alumnus.should be_invalid
      alumnus.email = "test@hpi-alumni.de"
      alumnus.should be_invalid
      alumnus.email = "test@bla.de"
      alumnus.should be_valid
    end
  end
end
