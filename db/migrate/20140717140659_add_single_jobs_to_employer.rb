class AddSingleJobsToEmployer < ActiveRecord::Migration
  def change
  	add_column :employers, :single_jobs_requested, :integer, null: false, default: 0
  end
end
