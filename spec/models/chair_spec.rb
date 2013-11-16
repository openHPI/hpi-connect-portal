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
  pending "add some examples to (or delete) #{__FILE__}"
end
