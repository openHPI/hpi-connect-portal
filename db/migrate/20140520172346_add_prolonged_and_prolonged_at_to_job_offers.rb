class AddProlongedAndProlongedAtToJobOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :prolong_requested, :boolean, default: false
    add_column :job_offers, :prolonged, :boolean, default: false
    add_column :job_offers, :prolonged_at, :datetime
  end
end
