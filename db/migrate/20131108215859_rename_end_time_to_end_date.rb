class RenameEndTimeToEndDate < ActiveRecord::Migration[4.2]
  def change
  	rename_column :job_offers, :end_time, :end_date
  end
end
