class AddVacantPostsToJobOffer < ActiveRecord::Migration
  def change
  	add_column :job_offers, :vacant_posts, :integer
  end
end
