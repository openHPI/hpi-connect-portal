class DataMigrationForReleaseDates < ActiveRecord::Migration
  def change
    JobOffer.where(release_date: nil).each do |job_offer|
      job_offer.update(release_date: job_offer.start_date)
    end
  end
end
