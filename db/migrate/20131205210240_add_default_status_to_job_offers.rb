class AddDefaultStatusToJobOffers < ActiveRecord::Migration[4.2]
  def change
  	change_column :job_offers, :status_id, :integer, :default => 1
  end
end
