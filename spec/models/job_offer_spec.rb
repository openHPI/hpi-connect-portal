# == Schema Information
#
# Table name: job_offers
#
#  id          :integer          not null, primary key
#  description :string(255)
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe JobOffer do
  before(:each) do
    @job_offer = JobOffer.create
  end

  subject { @job_offer }

  describe 'applying' do
    before do
      @user = User.create
      @application = Application.create(user: @user, job_offer: @job_offer)
    end

    its(:applications) { should include(@application) }
    its(:users) { should include(@user) }
  end
end
