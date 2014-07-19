# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  c_name           :string(255)
#  c_street         :string(255)
#  c_zip_city       :string(255)
#  c_email          :string(255)
#  c_phone          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
