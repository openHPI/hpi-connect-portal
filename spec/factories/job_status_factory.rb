# == Schema Information
#
# Table name: job_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryBot.define do
  factory :job_status do
    name "pending"
    initialize_with { JobStatus.find_or_create_by!(name: name) }
  end

  trait :pending do
    name 'pending'
  end

  trait :active do
    name 'active'
  end

  trait :closed do
    name 'closed'
  end
end
