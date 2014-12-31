class Rating < ActiveRecord::Base
  belongs_to :student
  belongs_to :employer
  belongs_to :job_offer
end
