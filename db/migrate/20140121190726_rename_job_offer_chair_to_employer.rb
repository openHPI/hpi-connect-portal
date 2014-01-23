class RenameJobOfferChairToEmployer < ActiveRecord::Migration
  def change
  	rename_column :job_offers, :chair_id, :employer_id
  end
end
