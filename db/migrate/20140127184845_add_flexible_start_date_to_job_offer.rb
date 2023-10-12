class AddFlexibleStartDateToJobOffer < ActiveRecord::Migration[4.2]
  def change
  	add_column :job_offers, :flexible_start_date, :boolean, :default => false
  end
end
