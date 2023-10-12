class AddStateIdToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :state_id, :integer, null: false, default: 3
  end
end
