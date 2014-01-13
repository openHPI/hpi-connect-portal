# == Schema Information
#
# Table name: job_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :job_status do
  	name "pending"
  	initialize_with { JobStatus.find_or_create_by!(name: name) }
  end

  trait :pending do 
    name 'pending'
  end

  trait :open do 
    name 'open'
  end

  trait :running do 
    name 'running'
  end

  trait :completed do 
    name 'completed'
  end
end
