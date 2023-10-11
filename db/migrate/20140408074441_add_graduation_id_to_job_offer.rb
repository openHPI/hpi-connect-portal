class AddGraduationIdToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :graduation_id, :integer, null: false, default: 2
  end
end
