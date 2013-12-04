class AddStatusToJobOffers < ActiveRecord::Migration
  def change
    add_column :job_offers, :status, :string
  end
end
