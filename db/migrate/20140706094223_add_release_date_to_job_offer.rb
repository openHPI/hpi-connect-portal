class AddReleaseDateToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :release_date, :date 
  end
end
