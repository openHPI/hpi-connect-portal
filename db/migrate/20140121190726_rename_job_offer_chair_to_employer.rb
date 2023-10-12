class RenameJobOfferChairToEmployer < ActiveRecord::Migration[4.2]
  def change
  	rename_column :job_offers, :chair_id, :employer_id
  end
end
