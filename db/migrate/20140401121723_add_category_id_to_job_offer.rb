class AddCategoryIdToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :category_id, :integer
  end
end
