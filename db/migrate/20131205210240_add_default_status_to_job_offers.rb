class AddDefaultStatusToJobOffers < ActiveRecord::Migration
  def change
  	change_column :job_offers, :status_id, :integer, :default => 1
  end
end
