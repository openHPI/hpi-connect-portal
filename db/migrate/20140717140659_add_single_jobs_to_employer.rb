class AddSingleJobsToEmployer < ActiveRecord::Migration[4.2]
  def change
  	add_column :employers, :single_jobs_requested, :integer, null: false, default: 0
  end
end
