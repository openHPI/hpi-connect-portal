class FinalChairEmployerMigration < ActiveRecord::Migration
  def change
  	rename_table :chairs_job_offers, :employers_job_offers
  	rename_column :employers_job_offers, :chair_id, :employer_id
  	rename_column :employers, :head_of_chair, :head
  end
end
