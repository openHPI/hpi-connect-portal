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
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'validation of attributes' do

    it 'with firstname not present' do
      @user.firstname = nil
      @user.should be_invalid
    end

    it 'with lastname not present' do
      @user.lastname = nil
      @user.should be_invalid
    end

    it 'with email not present' do
      @user.email = nil
      @user.should be_invalid
    end

    it 'with duplicate email' do
      @user.email = FactoryGirl.create(:user).email
      @user.should be_invalid
    end

    it 'as Alumnus with hpi email' do
      @user.alumni_email = @user.firstname + ' ' + @user.lastname
      @user.email = "test@hpi.de"
      @user.should be_invalid
      @user.email = "test@student.hpi.uni-potsdam.de"
      @user.should be_invalid
      @user.email = "test@hpi-alumni.de"
      @user.should be_invalid
      @user.email = "test@bla.de"
      @user.should be_valid
    end
  end
end
