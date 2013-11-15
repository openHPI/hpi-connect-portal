class RenameEndTimeToEndDate < ActiveRecord::Migration
  def change
  	rename_column :job_offers, :end_time, :end_date
  end
end
