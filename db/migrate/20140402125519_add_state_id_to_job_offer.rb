class AddStateIdToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :state_id, :integer, null: false, default: 3
  end
end
