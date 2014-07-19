# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  employer_id  :integer
#  job_offer_id :integer
#  name         :string(255)
#  street       :string(255)
#  zip_city     :string(255)
#  email        :string(255)
#  phone        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
