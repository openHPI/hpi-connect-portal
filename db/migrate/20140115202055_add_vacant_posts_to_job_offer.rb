class AddVacantPostsToJobOffer < ActiveRecord::Migration[4.2]
  def change
  	add_column :job_offers, :vacant_posts, :integer
  end
end
