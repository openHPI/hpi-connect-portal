class RemoveVacantPostsFromJobOffer < ActiveRecord::Migration
  def change
  	remove_column :job_offers, :vacant_posts
  end
end
