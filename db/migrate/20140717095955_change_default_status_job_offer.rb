class ChangeDefaultStatusJobOffer < ActiveRecord::Migration
  def change
    change_column :job_offers, :status_id, :integer, :default => nil
  end
end
