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
#  frequency          :integer          default(1), not null
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#

require 'spec_helper'

describe User do
  before(:each) do
    @english = Language.create(:name=>'english')
    @user = FactoryGirl.create(:user)
    @programming_language = FactoryGirl.create(:programming_language)
    @student = FactoryGirl.create(:user, :languages=>[@english], :programming_languages => [@programming_language])
  end

  subject { @user }

  describe 'applying' do
    before do
      @job_offer = FactoryGirl.create(:job_offer)
      @application = Application.create(user: @user, job_offer: @job_offer)
    end

    it { should be_applied(@job_offer) }
    its(:applications) { should include(@application) }
    its(:job_offers) { should include(@job_offer) }
  end

  describe 'build from identity_url' do

    it "should return the user with the corrent email and name" do
      url = "https://openid.hpi.uni-potsdam.de/user/max.meier"
      user =  User.new(
              identity_url: url,
              email: "max.meier@student.hpi.uni-potsdam.de",
              firstname: "Max",
              lastname: "Meier",
              semester: 1,
              academic_program: "unknown",
              education: "unknown",
              role: Role.where(name: "Student").first)
      expect(User.build_from_identity_url(url)).to eql(user)
    end
  end
end
