class AddGraduationIdToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :graduation_id, :integer, null: false, default: 2
  end
end
