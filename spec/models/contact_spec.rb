# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  name             :string(255)
#  street           :string(255)
#  zip_city         :string(255)
#  email            :string(255)
#  phone            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

describe Contact do
  before(:each) do
    @contact= FactoryGirl.create(:contact)
  end

  describe 'validation of methodes' do

    it 'validates is_empty' do
      @contact.name = nil
      @contact.street = nil
      @contact.zip_city = nil
      @contact.email = nil
      @contact.phone = "0"
      assert_equal(false, @contact.is_empty?)
      @contact.phone = nil
      assert_equal(true, @contact.is_empty?)
    end

    it 'validates merged' do
      @contact.name = "Rainer Zufall"
      @contact.street = nil
      @contact.zip_city = "Potsdam"
      @contact.email = nil
      @contact.phone = "0815"
      assert_equal("Rainer Zufall\nPotsdam\n0815", @contact.merged)
    end
  end
end
