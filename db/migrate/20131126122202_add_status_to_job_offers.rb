class AddStatusToJobOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :status, :string
  end
end
