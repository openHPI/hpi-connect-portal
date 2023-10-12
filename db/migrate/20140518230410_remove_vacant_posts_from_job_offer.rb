class RemoveVacantPostsFromJobOffer < ActiveRecord::Migration[4.2]
  def change
  	remove_column :job_offers, :vacant_posts
  end
end
