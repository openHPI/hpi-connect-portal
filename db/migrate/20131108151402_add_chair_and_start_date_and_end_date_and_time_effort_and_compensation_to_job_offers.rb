class AddChairAndStartDateAndEndDateAndTimeEffortAndCompensationToJobOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :chair, :string
    add_column :job_offers, :start_date, :datetime
    add_column :job_offers, :end_time, :datetime
    add_column :job_offers, :time_effort, :float
    add_column :job_offers, :compensation, :float
  end
end
