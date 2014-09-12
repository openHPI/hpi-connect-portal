class AddReleaseDateToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :release_date, :date 
  end
end
