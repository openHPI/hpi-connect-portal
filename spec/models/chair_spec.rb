# == Schema Information
#
# Table name: chairs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head_of_chair       :integer
#

require 'spec_helper'

describe Chair do
	before(:each) do
		@user = User.new(:email => "max.mustermann@student.hpi.uni-potsdam.de", :identity_url => "https://openid.hpi.uni-potsdam.de/user/max.mustermann", :firstname => "Max", :lastname => "mustermann")
    	@user.save
    	@chair = Chair.new("name" => "HCI", "description" => "Human Computer Interaction", "head_of_chair" => @user)
	end 

	describe "validation of parameters" do
		
		it "with name not present" do
			@chair.name = nil
			@chair.should be_invalid
		end
		it "with description not present" do
			@chair.description = nil
			@chair.should be_invalid
		end
		it "with head_of_chair not present" do
			@chair.head_of_chair = nil
			@chair.should be_invalid
		end
		it "with name is not unique" do
			chair_with_same_name = @chair.dup
			chair_with_same_name.save

			@chair.should be_invalid
		end
	end
	after(:each) do
		@chair = nil
		@user = nil
	end
end
