class AddCategoryToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :category_id, :integer, null: false, default: 0
  end
end
