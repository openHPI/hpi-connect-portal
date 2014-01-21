# == Schema Information
#
# Table name: employers
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
#  head                :string(255)      not null
#  deputy_id           :integer
#  external            :boolean          default(FALSE)
#

require 'spec_helper'

describe Employer do
	before(:each) do
    	@employer = FactoryGirl.create(:employer)
	end 

	describe "validation of parameters" do
		
		it "with name not present" do
			@employer.name = nil
			@employer.should be_invalid
		end

		it "with description not present" do
			@employer.description = nil
			@employer.should be_invalid
		end

		it "with head not present" do
			@employer.head = nil
			@employer.should be_invalid
		end

		it "with deputy not present" do
			@employer.deputy = nil
			@employer.should be_invalid
		end

		it "with deputies employer is not the employer itself" do
			@employer.deputy.employer = nil
			@employer.should be_valid
			@employer.deputy.should be_valid
		end

		it "with name is not unique" do
			employer_with_same_name = @employer.dup
			assert employer_with_same_name.should be_invalid
		end
	end
end
