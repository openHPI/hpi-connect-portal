# == Schema Information
#
# Table name: chairs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head_of_chair       :string(255)      not null
#  deputy_id           :integer
#

require 'spec_helper'

describe Chair do
	before(:each) do
    	@chair = Chair.new("name" => "HCI", "description" => "Human Computer Interaction", "head_of_chair" => "Prof. Patrick Baudisch", deputy: FactoryGirl.create(:user))
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

		it "with deputy not present" do
			@chair.deputy = nil
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
	end
end
