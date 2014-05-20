class AddProlongedAndProlongedAtToJobOffers < ActiveRecord::Migration
  def change
    add_column :job_offers, :prolonged, :boolean, default: false
    add_column :job_offers, :prolonged_at, :datetime
  end
end
