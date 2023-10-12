class RemoveChairFromJobOffer < ActiveRecord::Migration[4.2]
  def change
  	remove_column :job_offers, :chair
  	add_column :job_offers, :chair_id, :integer
  end
end
