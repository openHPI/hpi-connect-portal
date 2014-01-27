class AddFlexibleStartDateToJobOffer < ActiveRecord::Migration
  def change
  	add_column :job_offers, :flexible_start_date, :boolean, :default => false
  end
end
