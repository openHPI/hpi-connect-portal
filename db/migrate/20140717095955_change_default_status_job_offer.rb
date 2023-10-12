class ChangeDefaultStatusJobOffer < ActiveRecord::Migration[4.2]
  def change
    change_column :job_offers, :status_id, :integer, :default => nil
  end
end
